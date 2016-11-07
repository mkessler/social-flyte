# Users
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :authentications, dependent: :destroy

  def facebook_authentication
    authentications.find_by_network_id(Network.facebook.id)
  end
end
