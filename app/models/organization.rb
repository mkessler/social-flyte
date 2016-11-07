class Organization < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  validates :name, presence: true

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
