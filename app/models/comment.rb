class Comment < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_user_id, :network_user_name, :like_count, :message, :posted_at, presence: true
  validates :network_comment_id, presence: true, uniqueness: { scope: :post_id }

  scope :flagged, -> { where(flagged: true) }

  def self.to_csv
    attributes = [:network_user_name, :message, :attachment_url, :posted_at, :like_count, :flagged]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
