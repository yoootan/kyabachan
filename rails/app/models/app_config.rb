class AppConfig < ApplicationRecord
  def self.privacy_policy
    AppConfig.find_by!(key: 'privacy_policy').value
  end

  def self.terms_of_use
    AppConfig.find_by!(key: 'terms_of_use').value
  end

  def self.transactions_law
    AppConfig.find_by!(key: 'transactions_law').value
  end
end
