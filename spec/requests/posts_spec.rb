require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  ActiveJob::Base.queue_adapter = :test

  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:campaign) { FactoryGirl.create(:campaign, organization: organization) }
  let(:campaign_post) { FactoryGirl.create(:post, campaign: campaign) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:post, network_post_id: Faker::Number.number(10)) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:post, network_post_id: nil) }
  let(:protected_attributes) { { campaign_id: campaign.id } }

  describe 'GET /o/:organization_id/c/:campaign_id/p/new' do
    context 'when logged out' do
      before(:example) do
        get new_organization_campaign_post_path(organization, campaign)
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
          get new_organization_campaign_post_path(organization, campaign)
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

        it 'assigns post' do
          expect(assigns(:post)).to be_a(Post)
        end

        it 'renders new' do
          expect(response).to render_template(:new)
        end
      end

      context 'when non-member' do
        before(:example) do
          get new_organization_campaign_post_path(organization, campaign)
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

  describe 'GET /o/:organization_id/c/:campaign_id/p/:id' do
    context 'when logged out' do
      before(:example) do
        get organization_campaign_post_path(organization, campaign, campaign_post)
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
          get organization_campaign_post_path(organization, campaign, campaign_post)
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

        it 'assigns post' do
          expect(assigns(:post)).to eql(campaign_post)
        end

        it 'renders show' do
          expect(response).to render_template(:show)
        end
      end

      context 'when non-member' do
        before(:example) do
          get organization_campaign_post_path(organization, campaign, campaign_post)
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

  describe 'CREATE /o/:organization_id/c/:campaign_id/p' do
    context 'when logged out' do
      it 'does not change Post count' do
        expect{
          post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
        }.to_not change(Post, :count)
      end

      it 'does not enqueues sync post job' do
        expect {
          post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
        }.to_not have_enqueued_job(SyncPostJob)
      end

      context 'html request' do
        before(:example) do
          post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
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
          post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes, format: :json }
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
        campaign_post
        #post network_tokens_set_path, params: { network: 'facebook', token: Faker::Number.number(10), expires_at: 3600, format: :json }
      end

      context 'when member' do
        before(:example) do
          membership
        end

        context 'with valid attributes' do
          it 'increases Campaign count by 1' do
            expect{
              post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            }.to change(Post, :count).by(1)
          end

          it 'enqueues sync post job' do
            expect {
              post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            }.to have_enqueued_job(SyncPostJob)
          end

          context 'html request' do
            before(:example) do
              post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
            end

            it 'responds with 302' do
              expect(response).to have_http_status(302)
            end

            it 'redirects to organization' do
              expect(response).to redirect_to(organization_campaign_post_url(organization, campaign, assigns(:post)))
            end
          end

          context 'json request' do
            before(:example) do
              post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
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
              post organization_campaign_posts_path(organization, campaign), params: { post: invalid_attributes }
            }.to_not change(Post, :count)
          end

          it 'does not enqueues sync post job' do
            expect {
              post organization_campaign_posts_path(organization, campaign), params: { post: invalid_attributes }
            }.to_not have_enqueued_job(SyncPostJob)
          end

          context 'html request' do
            before(:example) do
              post organization_campaign_posts_path(organization, campaign), params: { post: invalid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
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
              post organization_campaign_posts_path(organization, campaign), params: { post: invalid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders campaign errors' do
              expect(response.body).to eq(assigns(:post).errors.to_json)
            end
          end
        end

        context 'with protected attributes' do
          it 'does not change campaign count' do
            expect{
              post organization_campaign_posts_path(organization, campaign), params: { post: protected_attributes }
            }.to_not change(Post, :count)
          end

          it 'does not enqueues sync post job' do
            expect {
              post organization_campaign_posts_path(organization, campaign), params: { post: protected_attributes }
            }.to_not have_enqueued_job(SyncPostJob)
          end

          context 'html request' do
            before(:example) do
              post organization_campaign_posts_path(organization, campaign), params: { post: protected_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
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
              post organization_campaign_posts_path(organization, campaign), params: { post: protected_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to be_a(Post)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              expect(response.body).to eq(assigns(:post).errors.to_json)
            end
          end
        end
      end

      context 'when non-member' do
        context 'with valid attributes' do
          it 'does not change Campaign count' do
            expect{
              post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            }.to_not change(Post, :count)
          end

          it 'responds with 302' do
            post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            post organization_campaign_posts_path(organization, campaign), params: { post: valid_attributes }
            expect(response).to redirect_to(organizations_url)
          end
        end
      end
    end
  end

  describe 'DESTROY /o/:organization_id/c/:campaign_id/p/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          delete organization_campaign_post_path(organization, campaign, campaign_post)
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
          delete organization_campaign_post_path(organization, campaign, campaign_post), params: { format: :json }
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
          campaign_post
        end

        context 'html request' do
          it 'deletes campaign' do
            expect{
              delete organization_campaign_post_path(organization, campaign, campaign_post)
            }.to change(Post, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_campaign_post_path(organization, campaign, campaign_post)
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_campaign_post_path(organization, campaign, campaign_post)
            expect(assigns(:campaign)).to eql(campaign)
          end

          it 'assigns post' do
            delete organization_campaign_post_path(organization, campaign, campaign_post)
            expect(assigns(:post)).to eql(campaign_post)
          end

          it 'responds with 302' do
            delete organization_campaign_post_path(organization, campaign, campaign_post)
            expect(response).to have_http_status(302)
          end

          it 'redirects to index' do
            delete organization_campaign_post_path(organization, campaign, campaign_post)
            expect(response).to redirect_to(organization_campaign_posts_path(organization, campaign))
          end
        end

        context 'json request' do
          it 'deletes campaign' do
            expect{
              delete organization_campaign_post_path(organization, campaign, campaign_post), params: { format: :json }
            }.to change(Post, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_campaign_post_path(organization, campaign, campaign_post), params: { format: :json }
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_campaign_post_path(organization, campaign, campaign_post), params: { format: :json }
            expect(assigns(:campaign)).to eql(campaign)
          end

          it 'assigns post' do
            delete organization_campaign_post_path(organization, campaign, campaign_post), params: { format: :json }
            expect(assigns(:post)).to eql(campaign_post)
          end
        end
      end

      context 'when non-member' do
        before(:example) do
          delete organization_campaign_post_path(organization, campaign, campaign_post)
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
