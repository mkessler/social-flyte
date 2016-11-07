class Comment < ApplicationRecord
  belongs_to :post

  validates :post_id, :network_comment_id, :network_user_id, :network_user_name, :like_count, :message, presence: true
end
