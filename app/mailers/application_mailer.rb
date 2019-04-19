class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILER_FROM"]
  layout 'mailer'
end
