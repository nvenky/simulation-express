mongoose = require('mongoose')
Race = mongoose.model('Race')

exports.show = (req, res) ->
    Race.findOne({market_id: parseInt(req.params.id)}, (err, race) ->
        return res.send "Error occurred - #{err}" if (err)
        res.json race
    )
