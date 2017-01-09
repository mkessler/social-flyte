class Users::RegistrationsController < Devise::RegistrationsController
  before_action :profile_breadcrumb

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def profile_breadcrumb
    add_breadcrumb 'My Profile', edit_user_registration_path
  end
end
