class Post < ApplicationRecord
  belongs_to :network
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :network_id, :network_post_id, presence: true
end
