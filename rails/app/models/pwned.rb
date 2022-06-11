class Pwned < ApplicationRecord
  belongs_to :pwned_tag
  paginates_per 100
end
