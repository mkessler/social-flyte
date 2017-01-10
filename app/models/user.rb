# Users
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :authentications, dependent: :destroy

  before_validation :set_name, on: [:create, :update]

  validates :first_name, :last_name, :name, presence: true

  def has_valid_network_token?(network)
    case network
    when Network.facebook
      true unless facebook_authentication.nil? || facebook_authentication.expired?
    else
      false
    end
  end

  def facebook_authentication
    authentications.find_by_network_id(Network.facebook.id)
  end

  private

  def set_name
    self.name = "#{first_name} #{last_name}"
  end
end
