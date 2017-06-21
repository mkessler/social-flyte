class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update, :accounts, :users, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /o
  # Platform dashboard
  def index
    set_meta_tags site: meta_title('My Organizations')
    add_breadcrumb 'My Organizations', organizations_path
    @organizations = current_user.organizations

    redirect_to new_organization_url if @organizations.empty?
    redirect_to organization_url(@organizations.first) if @organizations.count == 1
  end

  # GET /o/:id
  # GET /o/:id.json
  def show
    set_meta_tags site: meta_title(@organization.name)
    @campaigns = @organization.campaigns
  end

  # GET /o/:id/users
  def users
    set_meta_tags site: meta_title("#{@organization.name} Users")
    add_breadcrumb 'Users', organization_users_path(@organization)
    @users = @organization.users
  end

  # GET /o/new
  def new
    set_meta_tags site: meta_title('New Organization')
    add_breadcrumb 'New Organization', new_organization_path
    @organization = Organization.new
  end

  # GET /o/:id/edit
  def edit
    set_meta_tags site: meta_title("Edit #{@organization.name}")
    add_breadcrumb 'Edit', edit_organization_path(@organization)
  end

  # POST /o
  # POST /o.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if organization_params.present? && @organization.save
        @organization.memberships.create(user: current_user)
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /o/:id
  # PATCH/PUT /o/:id.json
  def update
    respond_to do |format|
      if organization_params.present? && @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /o/:id
  # DELETE /o/:id.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  # Don't allow :slug
  def organization_params
    params.require(:organization).permit(:name)
  end

  def record_not_found
    flash[:notice] = 'Uh-oh, looks like you tried to access an organization that either doesn\'t exist or that you\'re not a member of.'
    redirect_to organizations_url
  end
end
