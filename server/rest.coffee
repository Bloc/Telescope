bufferToJSON = (data) ->
  toString = undefined
  if data[0] and typeof data[0] is "number"
    toString = String.fromCharCode.apply(null, data)
    EJSON.parse toString
  else if typeof data is "string"
    EJSON.parse data
  else
    data

HTTP.methods
  "/api/users":
    post: (data) ->
      @setContentType "application/json"
      data = bufferToJSON(data)
      data.profile.email = data.email

      unless @query.authToken and @query.authToken is (process.env["REST_SECRET_KEY"] || "jUOwlepEtiGHudRzcIpZq")
        @setStatusCode 401
        return EJSON.stringify(message: "Unauthorized. Give a valid authToken as a parameter.")

      if existingUser = Meteor.users.findOne(email: data.email) || existingUser = Meteor.users.findOne(username: data.username)
        Meteor.users.update(existingUser._id, {$set: data})
        Accounts.setPassword(existingUser._id, data.password)
        return EJSON.stringify existingUser

      id = Accounts.createUser(data)
      EJSON.stringify Meteor.users.findOne(id)