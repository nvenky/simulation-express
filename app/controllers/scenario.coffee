mongoose = require('mongoose')
Race = mongoose.model('Race')

exports.simulate = (req, res) ->
     @simulation = req.body

     @marketFilterQuery = {status: 'CLOSED'}
     @marketFilterQuery['event.event_type_id'] = @simulation.marketFilter['eventTypeId'] if @simulation.marketFilter['eventTypeId']
     @marketFilterQuery['market_type'] = @simulation.marketFilter['marketType'] if @simulation.marketFilter['marketType']
     @marketFilterQuery['exchange_id'] = @simulation.marketFilter['exchangeId'] if @simulation.marketFilter['exchangeId']
     @marketFilterQuery['start_time'] = {$gte: new Date(@simulation.marketFilter['startDate'])} if @simulation.marketFilter['startDate']

     mapReducer = {}
     mapReducer.map = () ->
         Mapper = () ->
           map: (record) ->
            for scenario in scenarios
             for position in @positions(scenario, record.market_runners.length)
               @profitLoss(scenario, record, record.market_runners[position])

           positions: (scenario, size) ->
              switch(scenario.range)
                when 'ALL' then [0..(size - 1)]
                when 'TOP 1/2' then [0..(Math.round(size * 0.5) - 1)]
                when 'BOTTOM 1/2' then [Math.round(size * 0.5)..size-1]
                when 'TOP 1/3' then [0..(Math.round(size * 0.33) - 1)]
                when 'BOTTOM 1/3' then [Math.round(size * 0.66)..(size - 1)]
                else scenario.positions

            profitLoss: (scenario, market, market_runner) ->
               if market_runner and !isNaN(market_runner.actual_sp)
                 price = parseFloat(market_runner.actual_sp)
                 return 0 if (scenario.minOdds and scenario.minOdds > price) or (scenario.maxOdds and scenario.maxOdds < price)
                 if scenario.betType== 'BACK'
                   amt = if market_runner.status == 'WINNER' then (price * scenario.stake) - scenario.stake else -scenario.stake
                 else if  scenario.betType == 'LAY'
                   amt = if market_runner.status == 'WINNER' then -((price * scenario.stake) - scenario.stake) else scenario.stake
                 else #LAY (SP)
                   amt = if market_runner.status == 'WINNER' then -scenario.stake else (scenario.stake / price)
                 if amt > 0
                   emit(market._id, {ret: amt * ((100 - commission)/100), startTime: market.start_time})
                 else if amt < 0
                   emit(market._id, {ret: amt, startTime: market.start_time})
                 amt
         new Mapper().map(this)

       mapReducer.reduce = (key, values) ->
          reducedVal = {ret:  0, startTime: undefined}
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += Math.round(val.ret * 100) / 100
          #print("Key " + key + "  Actual value " + vals)
          #print("Reduced value " + reducedVal.ret)
          reducedVal.startTime = values[0].startTime
          reducedVal

       mapReducer.out = {inline: 1} #'something'
       mapReducer.query = @marketFilterQuery
       mapReducer.scope = @simulation
       mapReducer.verbose = true


       processResults = (data, stats) ->
         return {} if data.length == 0
         raceResultsSeries = []
         raceSummarySeries = []
         summaryAmount = 0
         lowestAmount = 0
         highestAmount = 0
         winningRaces = 0
         debugger
         series =  for result, i in data
            amount = result.value.ret
            raceResultsSeries.push(amount)
            summaryAmount += amount
            raceSummarySeries.push(summaryAmount)
            winningRaces += 1 if amount > 0
            lowestAmount = summaryAmount if summaryAmount < lowestAmount
            highestAmount = summaryAmount if summaryAmount > highestAmount

         summary =
            lowestAmount: lowestAmount
            highestAmount: highestAmount
            profitLoss: raceSummarySeries[raceSummarySeries.length - 1]
            winningRaces: winningRaces
            winningPercentage: (winningRaces * 100) / stats.counts.output
            counts: stats.counts
            series:
              raceResultsSeries: raceResultsSeries
              raceSummarySeries: raceSummarySeries


       Race.mapReduce mapReducer, (err, collection, stats) ->
            res.json 'response': processResults(collection, stats)
