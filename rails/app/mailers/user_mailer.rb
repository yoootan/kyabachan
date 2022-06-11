class UserMailer < ApplicationMailer
  def test_email_for_user(user)
    @user = User.find(user.id)
    mail(to: @user.email, subject: "【サービス名】Test Mail")
  end

  # Called by sorcery
  def activation_needed_email(user)
    @user = User.find(user.id)
    subject = "【サービス名】メールアドレス確認のご案内"
    mail(to: @user.email, subject: subject)
  end

  # Called by sorcery
  def activation_success_email(user)
    @user = User.find(user.id)
    subject = "【サービス名】会員登録完了のお知らせ"
    mail(to: @user.email, subject: subject)
  end

  # Called by sorcery
  def reset_password_email(user)
    @user = User.find(user.id)
    mail(to: @user.email, subject: "【サービス名】パスワード再設定手続きのご案内")
  end
end
