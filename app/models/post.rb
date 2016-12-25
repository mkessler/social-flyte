class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Make network_parent_id conditional on facebook when more networks added
  validates :campaign_id, :network_id, :network_parent_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: :campaign_id }
end
