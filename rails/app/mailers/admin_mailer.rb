class AdminMailer < ApplicationMailer
  def test_email_for_admin(admin)
    @admin = Admin.find(admin.id)
    mail(to: @admin.email, subject:  "【サービス名】Test Mail")
  end
end
