class User < ApplicationRecord
  include Discard::Model
  authenticates_with_sorcery!

  before_save :run_shrine_derivatives!

  private
    def run_shrine_derivatives!
      # EXAMPLE: icon_derivatives! if icon.present? && icon_data_change_to_be_saved
    end
end
