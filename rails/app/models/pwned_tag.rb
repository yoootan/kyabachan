class PwnedTag < ApplicationRecord
  has_many :pwneds
  paginates_per 100
end
