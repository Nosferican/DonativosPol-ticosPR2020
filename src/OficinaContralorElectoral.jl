module OficinaContralorElectoral

using HTTP: HTTP, request, escapeuri
using JSON3: JSON3
using LibPQ: LibPQ, Connection, execute, prepare, load!, unix2datetime, Dates.format, Date, DateFormat, datetime2unix, DateTime

const DateFormat_OCE = DateFormat("mm/dd/yyyy");

income_methods = request("GET",
                         "https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillHistoricIncomeMethodDropDownList")
income_methods = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
                    for elem in JSON3.read(income_methods.body)
                    if !isempty(elem[:Text])
                 ] |>
    sort!
political_orgs = request("GET",
                         "https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillHistoricPoliticalOrganizationDropDownList")
political_orgs = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
                   for elem in JSON3.read(political_orgs.body)
                   if !isempty(elem[:Text])
                 ] |>
    sort!
committees = request("GET",
                     "https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillHistoricCommitteeDropDownList")
committees = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
               for elem in JSON3.read(committees.body)
               if !isempty(elem[:Text])
             ] |>
    sort!
countries = request("GET",
                    "https://serviciosenlinea.oce.pr.gov/Home/Cascading_Get_Countries")
countries = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
              for elem in JSON3.read(countries.body)
              if !isempty(elem[:Text])
            ] |>
    sort!
states = request("GET",
                 "https://serviciosenlinea.oce.pr.gov/Home/Cascading_Get_States")
states = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
           for elem in JSON3.read(states.body)
           if !isempty(elem[:Text])
         ] |>
    sort!
cities = request("GET",
                 "https://serviciosenlinea.oce.pr.gov/Home/Cascading_Get_Cities")
cities = [ (value = parse(Int, elem[:Value]), text = strip(elem[:Text]))
           for elem in JSON3.read(cities.body)
           if !isempty(elem[:Text])
         ] |>
    sort!
cities[findfirst(x -> x.text == "Caguas", cities)]
function get_data(committe::AbstractString)
    committe = committees[100].value
    dateFrom_arg = Date("2020-05-01")
    dateTo_arg = Date("2020-05-01")
    sort_arg = ""
    page_arg = 1
    pageSize_arg = 1000
    group_arg = ""
    filter_arg = ""
    committeeId_arg = ""
    politicalOrganizationId_arg = 10
    countryCode_arg = ""
    stateCode_arg = ""
    cityCode_arg = ""
    incomeMethod_arg = ""
    fullName_arg = ""
    dateFrom_arg = 05%2F01%2F2020+12%3A00%3A00+a.m.
    dateTo_arg = 05%2F07%2F2020+12%3A00%3A00+a.m.
    amountMin_arg = ""
    amountMax_arg = ""
    loadResult_arg = true
    response = request("POST",
                       string("https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillPublishedDonorResultsGrid?",
                              join([string("sort=", sort_arg),
                                    string("page=", page_arg),
                                    string("pageSize=", pageSize_arg),
                                    string("group=", group_arg),
                                    string("filter=", filter_arg),
                                    string("committeeId=", committeeId_arg),
                                    string("politicalOrganizationId=", politicalOrganizationId_arg),
                                    string("countryCode=", countryCode_arg),
                                    string("stateCode=", stateCode_arg),
                                    string("cityCode=", cityCode_arg),
                                    string("incomeMethod=", incomeMethod_arg),
                                    string("fullName=", fullName_arg),
                                    string("dateFrom=", escapeuri(format(dateFrom_arg, DateFormat_OCE)), "+12%3A00%3A00+a.m."),
                                    string("dateTo=", escapeuri(format(dateTo_arg, DateFormat_OCE)), "+12%3A00%3A00+a.m."),
                                    string("amountMin=", amountMin_arg),
                                    string("amountMax=", amountMax_arg),
                                    string("loadResult=", loadResult_arg),
                                    ],
                                    '&')))
    response = request("POST",
                       "https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillPublishedDonorResultsGrid?sort=&page=1&pageSize=1000&group=&filter=&committeeId=&politicalOrganizationId=10&countryCode=&stateCode=&cityCode=&incomeMethod=&fullName=&dateFrom=05%2F01%2F2020+12%3A00%3A00+a.m.&dateTo=05%2F07%2F2020+12%3A00%3A00+a.m.&amountMin=&amountMax=&loadResult=true" ==
                       "https://serviciosenlinea.oce.pr.gov/PublishedDonor/FillPublishedDonorResultsGrid?sort=&page=1&pageSize=1000&group=&filter=&committeeId=&politicalOrganizationId=10&countryCode=&stateCode=&cityCode=&incomeMethod=&fullName=&dateFrom=05%2F01%2F2020+12%3A00%3A00+a.m.&dateTo=05%2F07%2F2020+12%3A00%3A00+a.m.&amountMin=&amountMax=&loadResult=true")
    json = collect(JSON3.read(response.body));
    json[1]
    json[2]
    json[3]
    json[4]
    propertynames(response)
    response.headers
    response.request
    string(10datetime2unix(unix2datetime(1575590400)))
    sort=&page=1&pageSize=20&group=&filter=&committeeId=&politicalOrganizationId=10&countryCode=&stateCode=&cityCode=&incomeMethod=&fullName=&dateFrom=06%2F26%2F2020+12%3A00%3A00+a.m.&dateTo=&amountMin=&amountMax=&loadResult=true
    function parse_node(node)
        (name = node.fullName)
    end
    chk = DataFrame(elem for elem in collect(json[1][2]))
    chk[!,:Date] .= unix2datetime.(parse.(Int, SubString.(chk.Date, 7, 16)))

    chk[chk.FullName .== "CRISTOBAL QUILES DECLET",:]
    names(chk)
    unix2datetime.(parse.(Int, SubString.(chk.Date, 7, 16)))
    json[2][2]
    collect(propertynames(json))
                       
                       
                       """
                       sort: 
                       page: 1
                       pageSize: 20
                       group: 
                       filter: 
                       committeeId: 
                       politicalOrganizationId: 
                       countryCode: 
                       stateCode: 
                       cityCode: 
                       incomeMethod: 
                       fullName: 
                       dateFrom: 
                       dateTo: 
                       amountMin: 
                       amountMax: 
                       loadResult: false                       
                       """)
end
    


collect(JSON3.read(political_orgs.body))
typeof(json[1]["value"])
propertynames(json[1])
end
