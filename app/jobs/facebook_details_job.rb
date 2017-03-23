class FacebookDetailsJob < ApplicationJob
  queue_as :default

  def perform(user)
    FacebookService.new(user).update_user_details
  end
end
