nodemailer = require 'nodemailer'

transport = nodemailer.createTransport("SMTP",
  service: "Gmail"
  auth:
    user: "idanserver@gmail.com"
    pass: "Reminder1"
)

exports.sendEmail = (data, type) ->
  mailOptions = getMailOptions(data, type)

  transport.sendMail mailOptions, (error, res) ->
    if error
      console.log error
    else
      console.log "Message sent: " + res.message
    transport.close()

getMailOptions = (data, type) ->
  html = getHtml data
  from = getFrom type
  subject = getSubject type

  mailOptions =
    from: from + " <idanserver@gmail.com>"
    to: "lasik66@gmail.com"
    subject: subject
    html: html

getFrom = (type) ->
  from = if type == "smart-iq"
    "MultiFocal Ad"
  else if type == "monovision"
    "Monovision Ad"

getSubject = (type) ->
  subject = if type == "smart-iq"
    "פניה חדשה מפרסומת של מולטיפוקל"
  else if type == "monovision"
    "פניה חדשה מפרסומת של מונו-ויז'ין"

getHtml = (data) ->
  "<div dir='rtl'>
    שם: #{data.name} <br>
    טלפון: #{data.phone} <br>
    אימייל: #{data.email} <br>
  </div>"