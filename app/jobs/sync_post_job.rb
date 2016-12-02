class SyncPostJob < ApplicationJob
  queue_as :default

  def perform(user, post)
    case post.network.name
      when 'Facebook'
        FacebookService.new(user, post).sync
      when 'Twitter'

      when 'Instagram'

    end

    post.reload
    post.update_attributes(
      synced_at: DateTime.now.utc,
      sync_count: post.sync_count + 1
    )
  end
end
