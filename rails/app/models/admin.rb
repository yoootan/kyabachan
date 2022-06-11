class Admin < ApplicationRecord
  include Discard::Model
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8, maximum: 32 }, if: -> { new_record? || changes[:password_digest] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:password_digest] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:password_digest] }
  validate :pwned_validate, if: -> { new_record? || changes[:password_digest] }

  enum status: {
    pending: 0,
    active: 1,
    suspend: 2,
  }, _prefix: true

  scope :actives, -> {
    kept.where(status: :active)
  }

  private
    def pwned_validate
      return if password.blank?
      password_sha256 = Digest::SHA256.hexdigest(password)
      if Pwned.find_by(password_sha256: password_sha256).present?
        errors.add(:password, 'は脆弱なパスワードであるため、登録することができません')
      end
    end
end
