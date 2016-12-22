require 'rails_helper'

RSpec.describe 'Campaigns', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:campaign) { FactoryGirl.create(:campaign, organization: organization) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:campaign) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:campaign, name: nil) }
  let(:protected_attributes) { { organization_id: Faker::Number.number(2) } }
  let(:update_attributes) { { name: Faker::Company.name } }
  let(:invalid_update_attributes) { { name: nil } }

  describe 'GET /o/:organization_id/campaigns' do
    context 'when logged out' do
      before(:example) do
        get organization_campaigns_path(organization)
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
      end

      context 'when member' do
        before(:example) do
          membership
          campaign
          get organization_campaigns_path(organization)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'assigns campaign' do
          expect(assigns(:campaigns)).to eq(organization.campaigns)
        end

        it 'renders index' do
          expect(response).to render_template(:index)
        end
      end

      context 'when non-member' do
        before(:example) do
          get organization_campaigns_path(organization)
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          expect(response).to redirect_to(organizations_path)
        end
      end
    end
  end

  describe 'GET /o/:organization_id/c/new' do
    context 'when logged out' do
      before(:example) do
        get new_organization_campaign_path(organization)
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
      end

      context 'when member' do
        before(:example) do
          membership
          get new_organization_campaign_path(organization)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'assigns campaign' do
          expect(assigns(:campaign)).to be_a(Campaign)
        end

        it 'renders new' do
          expect(response).to render_template(:new)
        end
      end

      context 'when non-member' do
        before(:example) do
          get new_organization_campaign_path(organization)
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          expect(response).to redirect_to(organizations_path)
        end
      end
    end
  end

  describe 'GET /o/:organization_id/c/:id' do
    context 'when logged out' do
      before(:example) do
        get organization_campaign_path(organization, campaign)
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
      end

      context 'when member' do
        before(:example) do
          membership
          get organization_campaign_path(organization, campaign)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'assigns campaign' do
          expect(assigns(:campaign)).to eql(campaign)
        end

        it 'renders show' do
          expect(response).to render_template(:show)
        end
      end

      context 'when non-member' do
        before(:example) do
          get organization_campaign_path(organization, campaign)
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          expect(response).to redirect_to(organizations_path)
        end
      end
    end
  end

  describe 'GET /o/:organization_id/c/:id/edit' do
    context 'when logged out' do
      before(:example) do
        get edit_organization_campaign_path(organization, campaign)
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
      end

      context 'when member' do
        before(:example) do
          membership
          get edit_organization_campaign_path(organization, campaign)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'assigns campaign' do
          expect(assigns(:campaign)).to eql(campaign)
        end

        it 'renders edit' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when non-member' do
        before(:example) do
          get edit_organization_campaign_path(organization, campaign)
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          expect(response).to redirect_to(organizations_path)
        end
      end
    end
  end

  describe 'CREATE /o/:organization_id/campaigns' do
    context 'when logged out' do
      it 'does not change Campaign count' do
        expect{
          post organization_campaigns_path(organization), params: { campaign: valid_attributes }
        }.to_not change(Campaign, :count)
      end

      context 'html request' do
        before(:example) do
          post organization_campaigns_path(organization), params: { campaign: valid_attributes }
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
          post organization_campaigns_path(organization), params: { campaign: valid_attributes, format: :json }
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

      context 'when member' do
        before(:example) do
          membership
        end

        context 'with valid attributes' do
          it 'increases Campaign count by 1' do
            expect{
              post organization_campaigns_path(organization), params: { campaign: valid_attributes }
            }.to change(Campaign, :count).by(1)
          end

          context 'html request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: valid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
            end

            it 'responds with 302' do
              expect(response).to have_http_status(302)
            end

            it 'redirects to organization' do
              expect(response).to redirect_to(organization_campaign_url(organization, assigns(:campaign)))
            end
          end

          context 'json request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: valid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
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
          it 'does not change Campaign count' do
            expect{
              post organization_campaigns_path(organization), params: { campaign: invalid_attributes }
            }.to_not change(Campaign, :count)
          end

          context 'html request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: invalid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
            end

            it 'responds with 200' do
              expect(response).to have_http_status(200)
            end

            it 'renders new' do
              expect(response).to render_template(:new)
            end
          end

          context 'json request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: invalid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders campaign errors' do
              expect(response.body).to eq(assigns(:campaign).errors.to_json)
            end
          end
        end

        context 'with protected attributes' do
          it 'does not change campaign count' do
            expect{
              post organization_campaigns_path(organization), params: { campaign: protected_attributes }
            }.to_not change(Campaign, :count)
          end

          context 'html request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: protected_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
            end

            it 'responds with 200' do
              expect(response).to have_http_status(200)
            end

            it 'renders new' do
              expect(response).to render_template(:new)
            end
          end

          context 'json request' do
            before(:example) do
              post organization_campaigns_path(organization), params: { campaign: protected_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to be_a(Campaign)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              expect(response.body).to eq(assigns(:campaign).errors.to_json)
            end
          end
        end
      end

      context 'when non-member' do
        context 'with valid attributes' do
          it 'does not change Campaign count' do
            expect{
              post organization_campaigns_path(organization), params: { campaign: valid_attributes }
            }.to_not change(Campaign, :count)
          end

          it 'responds with 302' do
            post organization_campaigns_path(organization), params: { campaign: valid_attributes }
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            post organization_campaigns_path(organization), params: { campaign: valid_attributes }
            expect(response).to redirect_to(organizations_url)
          end
        end
      end
    end
  end

  describe 'UPDATE /o/:organization_id/c/:id' do
    context 'when logged out' do
      it 'does not update campaign' do
        previous_name = campaign.name
        put organization_campaign_path(organization, campaign), params: { organization: invalid_update_attributes }
        expect(campaign.name).to eq(previous_name)
      end

      context 'html request' do
        before(:example) do
          put organization_campaign_path(organization, campaign), params: { campaign: update_attributes }
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
          put organization_campaign_path(organization, campaign), params: { campaign: update_attributes, format: :json }
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

      context 'when member' do
        before(:example) do
          membership
        end

        context 'with valid attributes' do
          it 'updates campaign' do
            previous_name = campaign.name
            put organization_campaign_path(organization, campaign), params: { campaign: update_attributes }
            campaign.reload
            expect(campaign.name).to_not eql(previous_name)
          end

          context 'html request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: update_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'responds with 302' do
              expect(response).to have_http_status(302)
            end

            it 'redirects to organization' do
              expect(response).to redirect_to(organization_campaign_url(organization, assigns(:campaign)))
            end
          end

          context 'json request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: update_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
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
            previous_name = campaign.name
            put organization_campaign_path(organization, campaign), params: { campaign: invalid_update_attributes }
            expect(campaign.name).to eq(previous_name)
          end

          context 'html request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: invalid_update_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'responds with 200' do
              expect(response).to have_http_status(200)
            end

            it 'renders edit' do
              expect(response).to render_template(:edit)
            end
          end

          context 'json request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: invalid_update_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders campaign errors' do
              expect(response.body).to eq(assigns(:campaign).errors.to_json)
            end
          end
        end

        context 'with protected attributes' do
          it 'does not update campaign' do
            previous_name = campaign.name
            put organization_campaign_path(organization, campaign), params: { campaign: protected_attributes }
            expect(campaign.name).to eq(previous_name)
          end

          context 'html request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: protected_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'responds with 200' do
              expect(response).to have_http_status(200)
            end

            it 'renders edit' do
              expect(response).to render_template(:edit)
            end
          end

          context 'json request' do
            before(:example) do
              put organization_campaign_path(organization, campaign), params: { campaign: protected_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              expect(response.body).to eq(assigns(:campaign).errors.to_json)
            end
          end
        end
      end

      context 'when non-member' do
        context 'with valid attributes' do
          it 'does not update campaign' do
            previous_name = campaign.name
            put organization_campaign_path(organization, campaign), params: { organization: update_attributes }
            expect(campaign.name).to eq(previous_name)
          end

          it 'responds with 302' do
            put organization_campaign_path(organization, campaign), params: { campaign: update_attributes }
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            put organization_campaign_path(organization, campaign), params: { campaign: update_attributes }
            expect(response).to redirect_to(organizations_url)
          end
        end
      end
    end
  end

  describe 'DESTROY /o/:organization_id/campaign/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          delete organization_campaign_path(organization, campaign)
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
          delete organization_campaign_path(organization, campaign), params: { format: :json }
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

      context 'when member' do
        before(:example) do
          membership
          campaign
        end

        context 'html request' do
          it 'deletes campaign' do
            expect{
              delete organization_campaign_path(organization, campaign)
            }.to change(Campaign, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_campaign_path(organization, campaign)
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_campaign_path(organization, campaign)
            expect(assigns(:campaign)).to eql(campaign)
          end

          it 'responds with 302' do
            delete organization_campaign_path(organization, campaign)
            expect(response).to have_http_status(302)
          end

          it 'redirects to index' do
            delete organization_campaign_path(organization, campaign)
            expect(response).to redirect_to(organization_campaigns_path(organization))
          end
        end

        context 'json request' do
          it 'deletes campaign' do
            expect{
              delete organization_campaign_path(organization, campaign), params: { format: :json }
            }.to change(Campaign, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_campaign_path(organization, campaign), params: { format: :json }
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_campaign_path(organization, campaign), params: { format: :json }
            expect(assigns(:campaign)).to eql(campaign)
          end
        end
      end

      context 'when non-member' do
        before(:example) do
          delete organization_campaign_path(organization, campaign)
        end

        it 'responds with 302' do
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          expect(response).to redirect_to(organizations_path)
        end
      end
    end
  end
end
