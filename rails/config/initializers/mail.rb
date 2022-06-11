if ENV['RAILS_MAILER_DELIVERY'].blank?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: '176.34.43.29',
    port: 1025,
    enable_starttls_auto: false
  }
else
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', 'smtp.mailgun.org'),
    domain: ENV.fetch('SMTP_DOMAIN', 'mg.novelsystem.work'),
    port: ENV.fetch('SMTP_PORT', 587),
    user_name: ENV.fetch('SMTP_USER_NAME', Rails.application.credentials.dig(:smtp, :username)),
    password: ENV.fetch('SMTP_PASSWORD', Rails.application.credentials.dig(:smtp, :password)),
    authentication: 'plain',
    enable_starttls_auto: true
  }
end
