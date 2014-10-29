mongoose = require('mongoose')
Schema = mongoose.Schema

RaceSchema = new Schema({
  data: { type: String, default: {}}
})

mongoose.model('Race', RaceSchema)
