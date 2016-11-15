require 'rails_helper'

RSpec.describe 'Authentications', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:authentication, user_id: user.id) }

  describe 'GET /authentications' do
    context 'when logged out' do
      before(:example) do
        get authentications_path
      end

      it 'responds with 302' do
        expect(response).to have_http_status(302)
      end

      it 'redirects to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
        get authentications_path
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      # it 'assigns authenitcations' do
      #   expect(assigns(:authenitcations)).to eql(authenitcations)
      # end

      it 'renders index' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'CREATE /authentications' do
    context 'when logged out' do
      it 'does not change Authentication count' do
        expect{
          post authentications_path, params: { authentication: valid_attributes }
        }.to_not change(Authentication, :count)
      end

      context 'html request' do
        before(:example) do
          post authentications_path, params: { authentication: valid_attributes }
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to sign in' do
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'json request' do
        before(:example) do
          post authentications_path, params: { authentication: valid_attributes, format: :json }
        end

        it 'responds with json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'responds with 401' do
          expect(response).to have_http_status(401)
        end
      end
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
