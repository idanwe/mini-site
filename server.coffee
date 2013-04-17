express = require 'express'
path = require 'path'
nodemailer = require 'nodemailer'
util = require 'util'
expressValidator = require 'express-validator'
jade = require 'jade'


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

transport = nodemailer.createTransport("SMTP",
  service: "Gmail"
  auth:
    user: "idanserver@gmail.com" 
    pass: "Reminder1" 
)

app.get '/', (req, res) ->  
  res.render 'index', { success: false , errors: false, data: {}}

app.post '/', (req, res) ->
  validateData req
  errors = req.validationErrors true
  validData = composeValidData(req.body, errors)
  if errors
    res.render 'index', { success: false, errors: errors , data: validData}
  else
    sendMail validData
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

sendMail = (data) ->
  html = 
    "<div dir='rtl'>
      שם: #{data.name} <br>
      טלפון: #{data.phone} <br>
      אימייל: #{data.email} <br>
    </div>"

  mailOptions = 
    from: "MultiFocal Ad <idanserver@gmail.com>"
    to: "idanwe2@gmail.com " # lasik66@gmail.com
    subject: "פניה חדשה מפרסומת של מולטיפוקל"
    html: html
   
  transport.sendMail mailOptions, (error, res) -> 
    if error
      console.log error
    else
      console.log "Message sent: " + res.message
    transport.close()


app.post '/zullerSearch', (req, res) ->
  res.send zullerJSON
app.get '/zullerSearch', (req, res) ->
  res.send zullerJSON

zullerJSON = 
  "attractions": [ 
    "bar":
      "_id": "21931284150151458143"
      "name": "Grega"
      "logo": "url/gregaLogo"
      "minAge": "20"
      "address": 
        "city": "Herzelia"
        "street": "Harash"
        "streetNumber": "1"
      "date":
        "day": "14"
        "month": "4"
        "year": "2013"
      "weight": "1"
      "phoneNumber":"034124141"
      "music": ["main_stream", "rock", "israeli"]
    ,
    "club": 
      "_id": "21931284150151458143"
      "name": "Clara"
      "logo": "url/claraLogo"
      "minAge": "22"
      "address":
        "city": "Tel Aviv"
        "street": "Kaufman"
        "streetNumber": "1"
      "date":
        "day": "22"
        "month": "4"
        "year": "2013"
      "weight":"2"
      "music": ["main_stream", "house", "pop"]
      "phoneNumber":"034124141"
  ]


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


