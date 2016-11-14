class Network < ApplicationRecord
  has_many :authentications
  has_many :posts

  validates :name, :slug, presence: true, uniqueness: true

  def self.facebook
    find_by_slug('facebook')
  end

  def self.twitter
    find_by_slug('twitter')
  end

  def self.instagram
    find_by_slug('instagram')
  end
end
