nodemailer = require 'nodemailer'

transport = nodemailer.createTransport("SMTP",
  service: "Gmail"
  auth:
    user: "idanserver@gmail.com"
    pass: "Reminder1"
)

exports.sendEmail = (data) ->
  html =
    "<div dir='rtl'>
      שם: #{data.name} <br>
      טלפון: #{data.phone} <br>
      אימייל: #{data.email} <br>
    </div>"

  console.log "transport", transport
  mailOptions =
    from: "MultiFocal Ad <idanserver@gmail.com>"
    to: "lasik66@gmail.com"
    subject: "פניה חדשה מפרסומת של מולטיפוקל"
    html: html

  transport.sendMail mailOptions, (error, res) ->
    if error
      console.log error
    else
      console.log "Message sent: " + res.message
    transport.close()