module.exports = ['$scope', '$http', '$log', ($scope, $http, $log) ->
      require('./../../styles/simulation.scss')
      HighCharts = require('./../dependencies/highcharts.4.0.4.js')
      require('./../dependencies/highcharts-more.js')
      require('./../dependencies/highcharts-exporting.js')

      $scope.exchanges = [{id: 2, name:'Australia'},{id: 1, name: 'International'}]
      $scope.eventTypes = [{id: 7, name: 'Horse Racing'},{id: 4339, name: 'Greyhound Racing'}]
      $scope.venues = ["Aintree", "Albany", "Albion Park", "Albury", "Alice Springs", "Angle Park", "Aqueduct", "Ararat",
         "Armidale", "Ascot", "Auteuil", "Avoca", "Ayr", "Bacchus Marsh", "Baden-Baden", "Bairnsdale", "Balaklava", "Ballarat", 
         "Ballina", "Ballinrobe", "Bangor", "Bankstown", "Bath", "Bathurst", "Beaudesert", "Belle Vue", "Bellewstown", "Belmont", 
         "Belmont Park", "Benalla", "Bendigo", "Beverley", "Blayney", "Boort", "Bordertown", "Bowraville", "Brighton", "Broken Hill", 
         "Broome", "Bulli", "Bunbury", "Bundaberg", "Burnie", "Busselton", "Cairns", "Camperdown", "Canberra", "Cannington", "Canterbury", 
         "Carlisle", "Carnarvon", "Carnarvon ", "Carrick", "Cartmel", "Casino", "Casterton", "Catterick", "Caulfield", "Cessnock",
         "Chantilly", "Charles Town", "Charleville", "Charlton", "Cheltenham", "Chepstow", "Chester", "Clairwood", "Clare", "Clonmel", 
         "Cobram", "Coffs Harbour", "Colac", "Coleraine", "Coolamon", "Coonabarabran", "Coonamble", "Cootamundra", "Cork", "Corowa", "Cowra",
         "Cranbourne", "Crayford", "Curragh", "Dalby", "Dapto", "Darwin", "Deagon", "Deauville", "Delaware Park", "Delta Downs", "Devonport",
         "Donald", "Doncaster", "Doomben", "Down Royal", "Downpatrick", "Dubbo", "Dundalk", "Dunkeld", "Durbanville", "Dusseldorf", "Eagle Farm", 
         "Echuca", "Edenhope", "Emerald", "Emerald Downs", "Epsom", "Esperance", "Eugowra", "Evangeline Downs", "Exeter", "Fairfield", "Fairview",
         "Fairyhouse", "Fakenham", "Ffos Las", "Flamingo Park", "Flemington", "Fontwell", "Forbes", "Fort Erie", "Galway", "Gatton", "Gawler",
         "Geelong", "Geraldton", "Gilgandra", "Glen Innes", "Globe Derby", "Gloucester Park", "Gold Coast", "Goodwood", "Goondiwindi", "Gosford",
         "Goulburn", "Gowran Park", "Grafton", "Greyville", "Griffith", "Gunbower", "Gundagai", "Gunnedah", "Halidon", "Hall Green", "Hamilton",
         "Hanging Rock", "Harvey", "Hawkesbury", "Hawthorne", "Haydock", "Healesville", "Henlow", "Hexham", "Hobart", "Horsham", "Hove", "Huntingdon",
         "Innisfail", "Inverell", "Ipswich", "Jebel Ali", "Junee", "Kalgoorlie", "Kangaroo Island", "Kapunda", "Keeneland", "Kellerberrin", "Kelso",
         "Kembla Grange", "Kempsey", "Kempton", "Kenilworth", "Kerang", "Kilbeggan", "Kilcoy", "Killarney", "Kilmore", "Kinsley", "Kyneton",
         "Launceston", "Laytown", "Leeton", "Leicester", "Leopardstown", "Limerick", "Lingfield", "Lismore", "Listowel", "Longchamp", "Longford",
         "Louisiana Downs", "Ludlow", "MAISONS-LAFFITTE", "Mackay", "Maisons-Laffitte", "Maitland", "Manangatang", "Mandurah", "Market Rasen",
         "Maryborough", "Meadowlands", "Melton", "Menangle", "Mildura", "Moe", "Monmore", "Monmouth Park", "Moonee Valley", "Moree", "Mornington",
         "Morphettville", "Mortlake", "Moruya", "Mount Barker", "Mount Gambier", "Mount Isa", "Mountaineer Park", "Mudgee", "Murray Bridge", "Murtoa",
         "Murwillumbah", "Musselburgh", "Muswellbrook", "Naas", "Naracoorte", "Narrabri", "Narrandera", "Narrogin", "Narromine", "Navan", "Newbury",
         "Newcastle", "Newmarket", "Newton Abbot", "Northam", "Nottingham", "Nottingham (Evening)", "Nowra", "Nyah", "Oakbank", "Orange", "Ouyen",
         "Pakenham", "Parkes", "Parx Racing", "Peak Hill", "Penn National", "Penola", "Penrith", "Perry Barr", "Perth", "Peterborough", "Pinjarra",
         "Plumpton", "Pontefract", "Poole", "Port Augusta", "Port Hedland", "Port Lincoln", "Port Macquarie", "Port Pirie", "Presque Isle Downs",
         "Punchestown", "Queanbeyan", "Quirindi", "Randwick", "Redcar", "Redcliffe", "Richmond", "Ripon", "Rockhampton", "Roebourne", "Roma", "Romford",
         "Romford (Evening)", "Roscommon", "Rosehill", "Saint-Cloud", "Sale", "Salisbury", "Sandown", "Sandown Park", "Santa Anita", "Sapphire Coast",
         "Saratoga", "Scone", "Scottsville", "Sedgefield", "Seymour", "Sheffield", "Shelbourne", "Shelbourne Park", "Shepparton", "Sittingbourne",
         "Sligo", "Southwell", "St Arnaud", "St.Arnaud", "Stawell", "Stony Creek", "Stratford", "Strathalbyn", "Suffolk Downs", "Sunderland",
         "Sunshine Coast", "Swan Hill", "Swindon", "Tamworth", "Taree", "Tatura", "Temora", "Terang", "The Gardens", "The Meadows", "Thirsk",
         "Thurles", "Tipperary", "Toodyay", "Toowoomba", "Towcester", "Townsville", "Tramore", "Traralgon", "Turf Paradise", "Turffontein",
         "Uttoxeter", "Vaal", "Veliefendi (Istanbul)", "Victor Harbor", "Wagga", "Wagin", "Walcha", "Wangaratta", "Warracknabeal", "Warragul",
         "Warren", "Warrnambool", "Warwick", "Warwick Farm", "Wedderburn", "Wellington", "Wentworth Park", "Werribee", "West Wyalong", "Wetherby",
         "Wexford", "Whyalla", "Wimbledon", "Wincanton", "Windsor", "Wodonga", "Wolverhampton", "Woodbine", "Worcester", "Wyong", "Yarmouth",
         "Yarra Glen", "Yarra Valley", "Yeppoon", "York", "Young", "Zia Park"]

      $scope.marketTypes = ['WIN', 'PLACE']
      $scope.ranges = ['Custom', 'ALL', 'TOP 1/2', 'TOP 1/3', 'BOTTOM 1/2', 'BOTTOM 1/3']
      $scope.betTypes= ['BACK', 'LAY', 'LAY (SP)']
      $scope.simulationParams = {
          commission: 6.5,
          scenarios: [{stake: 5, range: 'Custom', betType: 'BACK'}],
          marketFilter: {marketType: 'WIN', exchangeId: 2}
      }

      $scope.addScenario = ->
        $scope.simulationParams.scenarios.push({stake: 5, range: 'Custom', betType: 'BACK'})

      $scope.deleteScenario = (index)->
        $scope.simulationParams.scenarios.splice(index, 1)


      @renderSummary = (processedData) ->
        $scope.summary = processedData

      @renderChart = (processedData) =>
         @chart = new Highcharts.Chart
              chart:
                renderTo: 'chart',
                zoomType: 'x'
              animation: true
              exporting:
                enabled: true
              title:
                   text: 'Simulation Result'
              tooltip:
                valueDecimals: 2
              plotOptions:
                series:
                  cursor: 'pointer'
                  pointStart: 1
                  negativeColor: '#FF0000'
                  marker:
                     lineWidth: 1
                  point:
                    events:
                      click: (e) ->
                        $scope.loading = true
                        $http.get("/races/#{@x}")
                         .error ->
                            $scope.loading = false
                         .success (data, status) =>
                            $scope.loading = false
                            $scope.raceDetails = data

              series: [
                name: 'Earnings'
                data: processedData.series.raceResultsSeries
                type: 'column'
                negativeColor: '#FF0000'
               ,
                name: 'Summary'
                data: processedData.series.raceSummarySeries
                type: 'spline'
              ]

      $scope.run = =>
        $scope.loading = true
        $scope.summary = null
        $scope.raceDetails = null
        @chart.destroy() if @chart
        $http.post('/scenario/simulate', $scope.simulationParams)
          .error ->
            $scope.loading = false
          .success (data, status) =>
            $scope.loading = false
            processedData = data.response
            if !processedData or !processedData.series
              $('#chart').html 'No Data found'
              @chart = null
              return
            @renderSummary(processedData)
            @renderChart(processedData)
  ]
