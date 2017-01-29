# Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@groala.com'
  layout 'mailer'
end
