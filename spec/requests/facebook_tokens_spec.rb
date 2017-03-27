require 'rails_helper'

RSpec.describe "FacebookTokens", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:user_two) { FactoryGirl.create(:user) }
  let(:facebook_token) { FactoryGirl.create(:facebook_token, user_id: user.id) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:facebook_token) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:facebook_token, token: nil) }
  let(:protected_attributes) { { user_id: user_two.id } }
  let(:update_attributes) { { token: '1234' } }
  let(:invalid_update_attributes) { { token: nil } }

  describe 'CREATE /facebook_tokens' do
    context 'when logged out' do
      it 'does not change FacebookToken count' do
        expect{
          post facebook_tokens_path, params: { facebook_token: valid_attributes, format: :json }
        }.to_not change(FacebookToken, :count)
      end

      context 'json request' do
        before(:example) do
          post facebook_tokens_path, params: { facebook_token: valid_attributes, format: :json }
        end

        it 'responds with json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'responds with 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
      end

      context 'with valid attributes' do
        it 'increases FacebookToken count by 1' do
          VCR.use_cassette('facebook_get_user_details') do
            expect{
              post facebook_tokens_path, params: { facebook_token: valid_attributes, format: :json }
            }.to change(FacebookToken, :count).by(1)
          end
        end

        context 'json request' do
          before(:example) do
            VCR.use_cassette('facebook_get_user_details') do
              post facebook_tokens_path, params: { facebook_token: valid_attributes, format: :json }
            end
          end

          it 'assigns facebook_token' do
            expect(assigns(:facebook_token)).to be_a(FacebookToken)
          end

          it 'responds with 201' do
            expect(response).to have_http_status(201)
          end

          it 'responds with json' do
            expect(response.content_type).to eq('application/json')
          end

          it 'renders show' do
            expect(response).to render_template(:show)
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not change FacebookToken count' do
          VCR.use_cassette('facebook_get_user_details') do
            expect{
              post facebook_tokens_path, params: { facebook_token: invalid_attributes, format: :json }
            }.to_not change(FacebookToken, :count)
          end
        end

        context 'json request' do
          before(:example) do
            post facebook_tokens_path, params: { facebook_token: invalid_attributes, format: :json }
          end

          it 'assigns facebook_token' do
            expect(assigns(:facebook_token)).to be_a(FacebookToken)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders facebook token errors' do
            expect(response.body).to eq(assigns(:facebook_token).errors.to_json)
          end
        end
      end

      context 'with protected attributes' do
        it 'does not change FacebookToken count' do
          expect{
            post facebook_tokens_path, params: { facebook_token: protected_attributes, format: :json }
          }.to_not change(FacebookToken, :count)
        end

        context 'json request' do
          before(:example) do
            post facebook_tokens_path, params: { facebook_token: protected_attributes, format: :json }
          end

          it 'assigns facebook_token' do
            expect(assigns(:facebook_token)).to be_a(FacebookToken)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders facebook_token errors' do
            expect(response.body).to eq(assigns(:facebook_token).errors.to_json)
          end
        end
      end
    end
  end

  describe 'UPDATE /facebook_token/:id' do
    before(:example) do
      VCR.use_cassette('facebook_get_user_details') do
        facebook_token
      end
    end

    context 'when logged out' do
      it 'does not update facebook token' do
        previous_name = facebook_token.network_user_name
        put facebook_token_url(facebook_token), params: { facebook_token: { network_user_name: 'New Name' }, format: :json }
        expect(facebook_token.network_user_name).to eq(previous_name)
      end

      context 'json request' do
        before(:example) do
          put facebook_token_url(facebook_token), params: { facebook_token: update_attributes, format: :json }
        end

        it 'responds with json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'responds with 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
      end

      context 'with valid attributes' do
        it 'updates facebook token' do
          previous_token = facebook_token.token
          put facebook_token_url(facebook_token), params: { facebook_token: update_attributes, format: :json }
          facebook_token.reload
          expect(facebook_token.token).to_not eql(previous_token)
        end

        it 'updates expires_at' do
          put facebook_token_url(facebook_token), params: { facebook_token: { expires_at: '3600' }, format: :json }
          expect(facebook_token.expires_at).to be > Time.now
        end

        context 'json request' do
          before(:example) do
            put facebook_token_url(facebook_token), params: { facebook_token: update_attributes, format: :json }
          end

          it 'assigns facebook_token' do
            expect(assigns(:facebook_token)).to eql(facebook_token)
          end

          it 'responds with 200' do
            expect(response).to have_http_status(200)
          end

          it 'responds with json' do
            expect(response.content_type).to eq('application/json')
          end

          it 'renders show' do
            expect(response).to render_template(:show)
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not update campaign' do
          previous_token = facebook_token.token
          put facebook_token_url(facebook_token), params: { facebook_token: invalid_update_attributes, format: :json }
          expect(facebook_token.token).to eq(previous_token)
        end

        context 'json request' do
          before(:example) do
            put facebook_token_url(facebook_token), params: { facebook_token: invalid_update_attributes, format: :json }
          end

          it 'assigns facebook token' do
            expect(assigns(:facebook_token)).to eql(facebook_token)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders facebook token errors' do
            expect(response.body).to eq(assigns(:facebook_token).errors.to_json)
          end
        end
      end
    end
  end

  describe 'DESTROY /facebook_token/:id' do
    context 'when logged out' do
      context 'json request' do
        before(:example) do
          VCR.use_cassette('facebook_get_user_details') do
            delete facebook_token_path(facebook_token), params: { format: :json }
          end
        end

        it 'responds with json' do
          expect(response.content_type).to eq('application/json')
        end

        it 'responds with 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
      end

      context 'json request' do
        it 'deletes campaign' do
          VCR.use_cassette('facebook_get_user_details') do
            facebook_token
            expect{
              delete facebook_token_path(facebook_token), params: { format: :json }
            }.to change(FacebookToken, :count).by(-1)
          end
        end

        it 'assigns facebook token' do
          VCR.use_cassette('facebook_get_user_details') do
            facebook_token
            delete facebook_token_path(facebook_token), params: { format: :json }
            expect(assigns(:facebook_token)).to eql(facebook_token)
          end
        end
      end
    end
  end
end
