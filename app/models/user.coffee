mongoose = require('mongoose')
userPlugin = require('mongoose-user')
Schema = mongoose.Schema

UserSchema = new Schema
  name: { type: String, default: '' },
  email: { type: String, default: '' },
  hashed_password: { type: String, default: '' },
  salt: { type: String, default: '' }

UserSchema.plugin(userPlugin, {})

UserSchema.method({
})

UserSchema.static({
})

mongoose.model('User', UserSchema)
