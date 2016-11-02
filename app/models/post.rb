class Post < ApplicationRecord
  belongs_to :network
  has_many :reactions, dependent: :destroy
end
