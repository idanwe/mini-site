express = require 'express'
path = require 'path'
# util = require 'util'
expressValidator = require 'express-validator'
jade = require 'jade'
emailManager = require './email_manager'

app = express()

app.configure ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.set('port', process.env.PORT || 3000)

  app.use express.logger('dev') #  'default', 'short', 'tiny', 'dev'
  app.use express.bodyParser()
  app.use expressValidator
  app.use app.router
  app.use express.static(path.join(__dirname, 'public'))

app.listen app.get('port'), ->
  console.log 'server listening on ' + app.get('port')

app.get '/', (req, res) ->
  res.render 'index', { success: false , errors: false, data: {}}

app.post '/', (req, res) ->
  validateData req
  errors = req.validationErrors true
  validData = composeValidData(req.body, errors)
  if errors
    res.render 'index', { success: false, errors: errors , data: validData}
  else
    emailManager.sendEmail validData
    res.render 'index', { success: true, errors: false, name: validData.name}

validateData = (req) ->
  req.assert('name', 'required').notEmpty()
  req.assert('name', '2 to 30 characters required').len(2, 30)
  req.assert('phone', 'required').notEmpty()
  req.assert('phone', 'valid phone required').len(9, 10).isInt()
  req.assert('email', 'required').notEmpty()
  req.assert('email', 'valid email required').isEmail()

composeValidData = (body, errors = {}) ->
  data = {}
  data['name'] = body.name unless errors.name
  data['phone'] = body.phone unless errors.phone
  data['email'] = body.email unless errors.email
  data

# validateData = (name, phone, email) ->
#   err = {}
#   err.name = validateName name
#   err.phone = validatePhone phone
#   err.email = validateEmail email
#   err

# validateName = (name) ->
#   if name.length <= 1 || name.length > 30
#     false
#   else
#     true

# validatePhone = (phone) ->
#   phone = phone.replace(/[^0-9]/g, '')
#   if phone.length != 10 then false else true

# validateEmail = (email) ->
#   atpos = email.indexOf("@")
#   dotpos = email.lastIndexOf(".")
#   if ( email.length == 0 || atpos < 1 || dotpos < atpos + 2 || dotpos + 2 >= email.length )
#     false
#   else
#     true


