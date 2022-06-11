class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def test_email(email)
    mail(to: email, subject: "【サービス名】Test Mail")
  end
end
