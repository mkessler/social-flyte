class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :campaigns, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  after_create :regenerate_slug

  def slug_candidates
    [:name, [:name, :id]]
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def regenerate_slug
    slug = nil
    save
  end
end
