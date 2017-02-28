class SyncPostJob < ApplicationJob
  include ActiveJobStatus::Hooks

  queue_as :default

  def perform(user, post, token)
    case post.network.name
      when 'Facebook'
        FacebookService.new(user, post, token).sync
      when 'Twitter'
        TwitterService.new(post).sync
      when 'Instagram'

    end
  end
end
