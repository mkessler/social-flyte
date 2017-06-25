# Mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@socialflyte.com'
  layout 'mailer'
end
