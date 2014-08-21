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
      unless @query.authToken and @query.authToken is process.env["REST_SECRET_KEY"]
        @setStatusCode 401
        return EJSON.stringify(message: "Unauthorized. Give a valid authToken as a parameter.")
      return EJSON.stringify(message: "No user created! User with email " + data.email + " already exists.")  if Meteor.users.findOne(email: data.email)
      id = Accounts.createUser(data)
      EJSON.stringify Meteor.users.findOne(id)