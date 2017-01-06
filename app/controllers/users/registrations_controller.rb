class Users::RegistrationsController < Devise::RegistrationsController
  def edit
    add_breadcrumb 'My Profile', edit_user_registration_path
    super
  end
end
