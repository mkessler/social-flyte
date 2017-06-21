class SyncPostJob < ApplicationJob
  include ActiveJobStatus::Hooks

  queue_as :default

  def perform(post, user)
    FacebookService.new(user, post).sync
  end
end
