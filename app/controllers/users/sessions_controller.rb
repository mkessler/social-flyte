class Users::SessionsController < Devise::SessionsController
  before_action :sessions_meta_title

  private

  def sessions_meta_title
    set_meta_tags site: meta_title('Sign In')
  end
end
