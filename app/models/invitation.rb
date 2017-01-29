class Invitation < ApplicationRecord
  belongs_to :organization
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_validation :generate_token, on: :create
  before_create :set_recipient_id
  after_update :process

  validates :email, :organization, :sender_id, :token, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.organization_id, Time.now, rand].join)
  end

  def process
    if accepted? && recipient.present?
      recipient.memberships.create(organization: organization)
    end
  end

  def set_recipient_id
    if User.exists?(email: self.email)
      self.recipient_id = User.find_by_email(self.email).id
    end
  end

end
