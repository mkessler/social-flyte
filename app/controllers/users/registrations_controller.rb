class Users::RegistrationsController < Devise::RegistrationsController
  before_action :profile_breadcrumb

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        resource.process_invitation(params[:invitation_token]) if params[:invitation_token].present?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private

  def profile_breadcrumb
    add_breadcrumb 'My Profile', edit_user_registration_path
  end
end
