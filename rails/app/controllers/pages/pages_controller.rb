class Pages::PagesController < ApplicationController
  # テンプレートを使った静的なページはこちら
  def privacy
    @privacy_policy = AppConfig.privacy_policy
  end

  def terms
    @terms_of_use = AppConfig.terms_of_use
  end

  def law
    @transactions_law = AppConfig.transactions_law
  end
end
