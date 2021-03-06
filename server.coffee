express = require 'express'
path = require 'path'
util = require 'util'
jade = require 'jade'
expressValidator = require 'express-validator'
contactUsValidator = require './contact-us-validator'
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
  res.render 'smart-iq/index', { postUrl: "/", success: false , errors: false, data: {} }

app.post '/', (req, res) ->
  contactUsValidator.validateData req
  errors = req.validationErrors true
  validData = contactUsValidator.composeValidData(req.body, errors)
  if errors
    res.render 'smart-iq/index', { postUrl: "/", success: false, errors: errors , data: validData }
  else
    emailManager.sendEmail(validData, 'smart-iq')
    res.render 'smart-iq/index', { postUrl: "/", success: true, errors: false, name: validData.name }

app.get '/monovision', (req, res) ->
  res.render 'monovision/index', { postUrl: "/monovision", success: false , errors: false, data: {} }

app.post '/monovision', (req, res) ->
  contactUsValidator.validateData req
  errors = req.validationErrors true
  validData = contactUsValidator.composeValidData(req.body, errors)
  if errors
    res.render 'monovision/index', { postUrl: "/monovision", success: false, errors: errors , data: validData }
  else
    emailManager.sendEmail(validData, 'monovision')
    res.render 'monovision/index', { postUrl: "/monovision", success: true, errors: false, name: validData.name }