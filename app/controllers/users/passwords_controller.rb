class Users::PasswordsController < Devise::PasswordsController
  before_action :sessions_meta_title

  private

  def sessions_meta_title
    set_meta_tags site: meta_title('Reset Password')
  end
end
