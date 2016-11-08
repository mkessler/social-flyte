require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  describe 'GET /authentications' do
    it 'denies access without logged in user' do
      get authentications_path
      expect(response).to have_http_status(302)
      expect(response).to redirect_to new_user_session_path
    end

    it 'accesses index with logged in user' do
      sign_in(@user)

      get authentications_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /authentications' do
    it 'denies access without logged in user' do
      user = FactoryGirl.create(:user)
      authentication_attributes = FactoryGirl.attributes_for(
        :authentication,
        user_id: user.id
      )

      expect {
        post authentications_path, params: { authentication: authentication_attributes, format: :json }
      }.to_not change(Authentication, :count)
      expect(response).to have_http_status(401)
      expect(response.content_type).to eq('application/json')
    end

    # it 'creates an authentication record with logged in user' do
    #   user = FactoryGirl.create(:user)
    #   sign_in(@user)
    #   authentication_attributes = FactoryGirl.attributes_for(
    #     :authentication,
    #     user_id: user.id
    #   )
    #
    #   expect {
    #     post authentications_path, params: { authentication: authentication_attributes, format: :json }
    #   }.to change(Authentication, :count)
    #   expect(response).to have_http_status(200)
    #   expect(response.content_type).to eq('application/json')
    #   expect(user.authentications.count).to eql(1)
    # end
  end
end
