mongoose = require('mongoose')
Race = mongoose.model('Race')

exports.simulate = (req, res) ->
     @marketFilterQueryKey = (filter) ->
       switch(filter)
         when 'eventTypeId' then 'event.event_type_id'
         else @camelCaseToUnderscore(filter)         
     @camelCaseToUnderscore = (str) ->
        str.replace(/([a-z\d])([A-Z])/g, '$1_$2').toLowerCase()

     @simulation = req.body

     @marketFilterQuery = {status: 'CLOSED'}
     eventTypeId = @marketFilterQuery.eventTypeId
     for key of Object.keys(@simulation.marketFilter)
         @marketFilterQuery[@marketFilterQueryKey(key)] = @simulation.marketFilter[key] if @simulation.marketFilter[key]

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

       Race.mapReduce mapReducer, (err, collection, stats) ->
           #console.log('map reduce took %d ms', stats.processtime)
            res.json 'stats': stats, 'response': collection
