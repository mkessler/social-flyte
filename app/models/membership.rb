class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  validates :organization_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :organization_id }
end
