class SyncPostJob < ApplicationJob
  include ActiveJobStatus::Hooks

  queue_as :default

  def perform(user, post)
    case post.network.name
      when 'Facebook'
        FacebookService.new(user, post).sync
      when 'Twitter'

      when 'Instagram'

    end
  end
end
