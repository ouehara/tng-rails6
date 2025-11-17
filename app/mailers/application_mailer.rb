class ApplicationMailer < ActionMailer::Base
  default from: ENV['TNG_SENDER_ADDRESS']
  layout 'mailer'
end
