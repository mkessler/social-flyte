class Post < ApplicationRecord
  belongs_to :network
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy
end
