class Campaign < ApplicationRecord
  extend FriendlyId
  belongs_to :organization
  has_many :posts, dependent: :destroy
  friendly_id :name, use: :scoped, scope: :organization

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: { scope: :organization_id }

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def engagement_count
    posts.map(&:engagement_count).sum
  end

  def flagged_interactions
    posts.map(&:flagged_interactions).flatten
  end

  def networks
    posts.map(&:network).map(&:slug).uniq.sort
  end
end
