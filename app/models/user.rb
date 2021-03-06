# Users
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy
  has_one :facebook_token, dependent: :destroy

  before_validation :set_name, on: [:create, :update]

  validates :first_name, :last_name, :name, presence: true

  def has_valid_facebook_token?
    facebook_token.present? && !facebook_token.expired?
  end

  # def process_invitation(token)
  #   if has_valid_invitation?(token)
  #     Invitation.find_by_email_and_token(self.email, token).update_attributes(
  #       accepted: true,
  #       recipient_id: self.id
  #     )
  #   end
  # end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def set_name
    self.name = "#{first_name} #{last_name}"
  end

  # def has_valid_invitation?(token)
  #   Invitation.where(email: self.email, token: token).exists?
  # end
end
