class Reaction < ApplicationRecord
  belongs_to :post

  scope :angry, -> { where(category: 'ANGRY') }
  scope :haha, -> { where(category: 'HAHA') }
  scope :like, -> { where(category: 'LIKE') }
  scope :love, -> { where(category: 'LOVE') }
  scope :sad, -> { where(category: 'SAD') }
  scope :wow, -> { where(category: 'WOW') }
end
