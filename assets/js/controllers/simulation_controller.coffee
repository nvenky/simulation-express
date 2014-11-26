module.exports = ['$scope', '$http', '$log', ($scope, $http, $log) ->
      require('./../../styles/simulation.scss')
      HighCharts = require('./../dependencies/highcharts.4.0.4.js')
      require('./../dependencies/highcharts-more.js')
      require('./../dependencies/highcharts-exporting.js')
      $scope.exchanges = [{id: 1, name:'Australia'},{id: 2, name: 'International'}]
      $scope.eventTypes = [{id: 7, name: 'Horse Racing'},{id: 4339, name: 'Greyhound Racing'}]

      $scope.marketTypes = ['WIN', 'PLACE']
      $scope.ranges = ['Custom', 'ALL', 'TOP 1/2', 'TOP 1/3', 'BOTTOM 1/2', 'BOTTOM 1/3']
      $scope.betTypes= ['BACK', 'LAY', 'LAY (SP)']
      $scope.simulationParams = {
          commission: 6.5,
          scenarios: [{stake: 5, range: 'Custom', betType: 'BACK'}],
          marketFilter: {marketType: 'WIN', exchangeId: 1}
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
                        $('#race-details').html("Hurray.. Got it #{@x} - #{@y}")
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
        @chart.destroy() if @chart
        $http.post('/scenario/simulate', $scope.simulationParams)
          .error ->
            $scope.loading = false
          .success (data, status) =>
            $scope.loading = false
            processedData = data.response
            if !processedData or !processedData.series
              $('#chart').html 'No Data found'
              return
            @renderSummary(processedData)
            @renderChart(processedData)
  ]
