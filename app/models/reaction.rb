class Reaction < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_user_name, :network_user_picture, :category, presence: true
  validates :network_user_id, presence: true, uniqueness: { scope: :post_id }

  scope :angry, -> { where(category: 'ANGRY') }
  scope :haha, -> { where(category: 'HAHA') }
  scope :like, -> { where(category: 'LIKE') }
  scope :love, -> { where(category: 'LOVE') }
  scope :sad, -> { where(category: 'SAD') }
  scope :wow, -> { where(category: 'WOW') }
  scope :flagged, -> { where(flagged: true) }

  def posted_at
    nil
  end
end
