require 'rails_helper'

RSpec.describe "TwitterTokens", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:twitter_token) { FactoryGirl.create(:twitter_token, organization_id: organization.id) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:twitter_token) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:twitter_token, token: nil) }
  let(:protected_attributes) { { organization_id: Faker::Number.number(2) } }
  let(:update_attributes) { { token: '1234' } }
  let(:invalid_update_attributes) { { token: nil } }

  # describe 'CREATE /twitter_tokens' do
  #   context 'when logged out' do
  #     it 'does not change TwitterToken count' do
  #       expect{
  #         post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #       }.to_not change(TwitterToken, :count)
  #     end
  #
  #     context 'html request' do
  #       before(:example) do
  #         post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #       end
  #
  #       it 'responds with 302' do
  #         expect(response).to have_http_status(302)
  #       end
  #
  #       it 'redirects to sign in' do
  #         expect(response).to redirect_to(new_user_session_path)
  #       end
  #     end
  #
  #     context 'json request' do
  #       before(:example) do
  #         post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id, format: :json }
  #       end
  #
  #       it 'responds with json' do
  #         expect(response.content_type).to eq('application/json')
  #       end
  #
  #       it 'responds with 401' do
  #         expect(response).to have_http_status(401)
  #       end
  #     end
  #   end
  #
  #   context 'when logged in' do
  #     before(:example) do
  #       sign_in(user)
  #     end
  #
  #     context 'when member' do
  #       before(:example) do
  #         membership
  #         TwitterTokensController.stub(:auth_hash).and_return(mock_auth_hash)
  #       end
  #
  #       context 'with valid attributes' do
  #         it 'increases TwitterToken count by 1' do
  #           expect{
  #             post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #           }.to change(TwitterToken, :count).by(1)
  #         end
  #
  #         context 'html request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 302' do
  #             expect(response).to have_http_status(302)
  #           end
  #
  #           it 'redirects to twitter_token' do
  #             expect(response).to redirect_to(organization_url(organization))
  #           end
  #         end
  #
  #         context 'json request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id, format: :json }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 201' do
  #             expect(response).to have_http_status(201)
  #           end
  #
  #           it 'responds with json' do
  #             expect(response.content_type).to eq('application/json')
  #           end
  #
  #           it 'renders show' do
  #             expect(response).to render_template(:show)
  #           end
  #         end
  #       end
  #
  #       context 'with invalid attributes' do
  #         it 'does not change TwitterToken count' do
  #           expect{
  #             post twitter_tokens_path, params: { twitter_token: invalid_attributes, organization_id: organization.id }
  #           }.to_not change(TwitterToken, :count)
  #         end
  #
  #         context 'html request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: invalid_attributes, organization_id: organization.id }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 200' do
  #             expect(response).to have_http_status(200)
  #           end
  #
  #           it 'renders new' do
  #             expect(response).to render_template(:new)
  #           end
  #         end
  #
  #         context 'json request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: invalid_attributes, organization_id: organization.id, format: :json }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 422' do
  #             expect(response).to have_http_status(422)
  #           end
  #
  #           it 'renders twitter_token errors' do
  #             expect(response.body).to eq(assigns(:twitter_token).errors.to_json)
  #           end
  #         end
  #       end
  #
  #       context 'with protected attributes' do
  #         it 'does not change twitter_token count' do
  #           expect{
  #             post twitter_tokens_path, params: { twitter_token: protected_attributes, organization_id: organization.id }
  #           }.to_not change(TwitterToken, :count)
  #         end
  #
  #         context 'html request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: protected_attributes, organization_id: organization.id }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 200' do
  #             expect(response).to have_http_status(200)
  #           end
  #
  #           it 'renders new' do
  #             expect(response).to render_template(:new)
  #           end
  #         end
  #
  #         context 'json request' do
  #           before(:example) do
  #             post twitter_tokens_path, params: { twitter_token: protected_attributes, organization_id: organization.id, format: :json }
  #           end
  #
  #           it 'assigns organization' do
  #             expect(assigns(:organization)).to eql(organization)
  #           end
  #
  #           it 'assigns twitter_token' do
  #             expect(assigns(:twitter_token)).to be_a(TwitterToken)
  #           end
  #
  #           it 'responds with 422' do
  #             expect(response).to have_http_status(422)
  #           end
  #
  #           it 'renders twitter_token errors' do
  #             expect(response.body).to eq(assigns(:twitter_token).errors.to_json)
  #           end
  #         end
  #       end
  #     end
  #
  #     context 'when non-member' do
  #       context 'with valid attributes' do
  #         it 'does not change TwitterToken count' do
  #           expect{
  #             post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #           }.to_not change(TwitterToken, :count)
  #         end
  #
  #         it 'responds with 302' do
  #           post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #           expect(response).to have_http_status(302)
  #         end
  #
  #         it 'redirects to organization' do
  #           post twitter_tokens_path, params: { twitter_token: valid_attributes, organization_id: organization.id }
  #           expect(response).to redirect_to(organizations_url)
  #         end
  #       end
  #     end
  #   end
  # end
end
