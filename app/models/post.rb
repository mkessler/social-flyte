class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :campaign_id, :network_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: :campaign_id }
end
