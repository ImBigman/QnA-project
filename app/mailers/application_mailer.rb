class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[:email][:sender]
  layout 'mailer'
end
