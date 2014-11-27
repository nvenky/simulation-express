mongoose = require('mongoose')
Race = mongoose.model('Race')

exports.simulate = (req, res) ->
     @simulation = req.body

     @marketFilterQuery = {status: 'CLOSED'}
     @marketFilterQuery['event.event_type_id'] = @simulation.marketFilter['eventTypeId'] if @simulation.marketFilter['eventTypeId']
     @marketFilterQuery['event.venue.name'] = @simulation.marketFilter['venue'] if @simulation.marketFilter['venue']
     @marketFilterQuery['market_type'] = @simulation.marketFilter['marketType'] if @simulation.marketFilter['marketType']
     @marketFilterQuery['exchange_id'] = @simulation.marketFilter['exchangeId'] if @simulation.marketFilter['exchangeId']
     @marketFilterQuery['start_time'] = {$gte: new Date(@simulation.marketFilter['startDate'])} if @simulation.marketFilter['startDate']
     @marketFilterQuery['start_time'] = {$lte: new Date(@simulation.marketFilter['endDate'])} if @simulation.marketFilter['endDate']

     mapReducer = {}
     mapReducer.map = () ->
         Mapper = () ->
           map: (record) ->
            for scenario in scenarios
             for position in @positions(scenario, record.market_runners.length)
               @profitLoss(scenario, record, record.market_runners[position-1])

           positions: (scenario, size) ->
              switch(scenario.range)
                when 'ALL' then [1..size]
                when 'TOP 1/2' then [1..(Math.round(size * 0.5))]
                when 'BOTTOM 1/2' then [Math.round(size * 0.5)..size]
                when 'TOP 1/3' then [1..(Math.round(size * 0.33))]
                when 'BOTTOM 1/3' then [Math.round(size * 0.66)..size]
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
                   emit(market.market_id, {ret: amt * ((100 - commission)/100), marketId: market.market_id})
                 else if amt < 0
                   emit(market.market_id, {ret: amt, marketId: market.market_id})
                 amt
         new Mapper().map(this)

       mapReducer.reduce = (key, values) ->
          reducedVal = {ret:  0, marketId: key}
          vals = []
          for val in values
             vals.push val.ret
             reducedVal.ret += Math.round(val.ret * 100) / 100
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
            marketId = result.value.marketId
            #raceResultsSeries.push(amount)
            raceResultsSeries.push(x: i, y: amount, id: marketId)
            summaryAmount += amount
            #raceSummarySeries.push(summaryAmount)
            raceSummarySeries.push(x: i, y: summaryAmount, id: marketId)
            # {marketId: marketId, x: i, y: summaryAmount})
            winningRaces += 1 if amount > 0
            lowestAmount = summaryAmount if summaryAmount < lowestAmount
            highestAmount = summaryAmount if summaryAmount > highestAmount

         summary =
            lowestAmount: lowestAmount
            highestAmount: highestAmount
            profitLoss: summaryAmount
            winningRaces: winningRaces
            winningPercentage: (winningRaces * 100) / stats.counts.output
            counts: stats.counts
            series:
              raceResultsSeries: raceResultsSeries
              raceSummarySeries: raceSummarySeries


       Race.mapReduce mapReducer, (err, collection, stats) ->
            res.json 'response': processResults(collection, stats)
