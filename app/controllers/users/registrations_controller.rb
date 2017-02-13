class Users::RegistrationsController < Devise::RegistrationsController

  # GET /resource/sign_up
  def new
    # set_meta_tags site: meta_title('Sign Up')
    # super
    flash[:notice] = 'Groala is currently not accepting registrations. Please check back later.'
    redirect_to root_url
  end

  # POST /resource
  def create
    # set_meta_tags site: meta_title('Sign Up')
    # build_resource(sign_up_params)
    #
    # resource.save
    # yield resource if block_given?
    # if resource.persisted?
    #   if resource.active_for_authentication?
    #     resource.process_invitation(params[:invitation_token]) if params[:invitation_token].present?
    #     set_flash_message! :notice, :signed_up
    #     sign_up(resource_name, resource)
    #     respond_with resource, location: after_sign_up_path_for(resource)
    #   else
    #     set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    #     expire_data_after_sign_in!
    #     respond_with resource, location: after_inactive_sign_up_path_for(resource)
    #   end
    # else
    #   clean_up_passwords resource
    #   set_minimum_password_length
    #   respond_with resource
    # end
    flash[:notice] = 'Groala is currently not accepting registrations. Please check back later.'
    redirect_to root_url
  end

  # GET /resource/edit
  def edit
    set_meta_tags site: meta_title('My Profile')
    add_breadcrumb 'My Profile', edit_user_registration_path
    super
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    set_meta_tags site: meta_title('My Profile')
    add_breadcrumb 'My Profile', edit_user_registration_path
    super
  end

  protected

  def after_update_path_for(resource)
    edit_user_registration_path
  end
end
