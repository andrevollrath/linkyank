class Member < ApplicationRecord
  validates :nid, uniqueness: true
end

