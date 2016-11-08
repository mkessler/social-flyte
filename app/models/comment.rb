class Comment < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_user_id, :network_user_name, :like_count, :message, :posted_at, presence: true
  validates :network_comment_id, presence: true, uniqueness: { scope: :post_id }
end
