class SyncPostJob < ApplicationJob
  include ActiveJobStatus::Hooks

  queue_as :default

  def perform(post, user=nil)
    case post.network.name
      when 'Facebook'
        FacebookService.new(user, post).sync
      when 'Twitter'
        TwitterService.new(post).sync
      when 'Instagram'

    end
  end
end
