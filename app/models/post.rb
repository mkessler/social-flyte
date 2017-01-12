class Post < ApplicationRecord
  belongs_to :campaign
  belongs_to :network
  has_many :reactions, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Make network_parent_id conditional on facebook when more networks added
  validates :campaign_id, :network_id, :network_parent_id, presence: true
  validates :network_post_id, presence: true, uniqueness: { scope: [:campaign_id, :network_id] }

  def engagement_count
    case network
      when Network.facebook
        comments.count + reactions.count
      when Network.twitter
        0
      when Network.instagram
        0
      else
        0
    end
  end

  def engagement_types
    case network
      when Network.facebook
        'Comments & Reactions'
      when Network.twitter
        0
      when Network.instagram
        0
      else
        0
    end
  end

  def flagged_interactions
    case network
      when Network.facebook
        comments.flagged.sort + reactions.flagged.sort
      else
        []
    end
  end
end
