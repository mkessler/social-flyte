class Network < ApplicationRecord
  has_many :access_tokens
  has_many :posts

  before_validation :set_slug, on: [:create, :update]

  validates :name, :slug, presence: true, uniqueness: true

  def self.facebook
    find_by_slug('facebook')
  end

  def self.instagram
    find_by_slug('instagram')
  end

  def self.twitter
    find_by_slug('twitter')
  end

  def user_link(user_id)
    case self
      when Network.facebook
        "https://facebook.com/#{user_id}"
      when Network.twitter

      when Network.instagram

    end
  end

  private

  def set_slug
    self.slug = name.try(:parameterize)
  end
end
