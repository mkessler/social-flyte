require 'rails_helper'

RSpec.describe 'Reactions', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:campaign) { FactoryGirl.create(:campaign, organization: organization) }
  let(:post) { FactoryGirl.create(:post, campaign: campaign) }
  let(:reaction) { FactoryGirl.create(:reaction, post: post) }
  let(:valid_attributes) { {flagged: true} }
  let(:invalid_attributes) { {flagged: "test"} }
  let(:protected_attributes) { {post_id: Faker::Number.number(10)} }

  describe 'GET /o/:organization_id/c/:campaign_id/p/:post_id/reactions' do
    context 'when logged out' do
      before(:example) do
        get organization_campaign_post_reactions_path(organization, campaign, post, format: :json)
      end

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
      end

      context 'when member' do
        before(:example) do
          membership
          get organization_campaign_post_reactions_path(organization, campaign, post, format: :json)
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
      end

      context 'when non-member' do
        before(:example) do
          get organization_campaign_post_reactions_path(organization, campaign, post, format: :json)
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

  describe 'UPDATE /o/:organization_id/c/:campaign_id/p/:post_id/reaction:id' do
    context 'when logged out' do
      it 'does not update reaction' do
        previous_flagged = reaction.flagged
        put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: valid_attributes, format: :js }
        expect(reaction.flagged).to eq(previous_flagged)
      end

      context 'js request' do
        before(:example) do
          put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: valid_attributes, format: :js }
        end

        it 'responds with js' do
          expect(response.content_type).to eq('text/javascript')
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
          it 'updates reaction' do
            previous_flagged = reaction.flagged
            put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: valid_attributes, format: :js }
            reaction.reload
            expect(reaction.flagged).to_not eql(previous_flagged)
          end

          context 'js request' do
            before(:example) do
              put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: valid_attributes, format: :js }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns campaign' do
              expect(assigns(:campaign)).to eql(campaign)
            end

            it 'assigns post' do
              expect(assigns(:post)).to eql(post)
            end

            it 'assigns reaction' do
              expect(assigns(:reaction)).to eql(reaction)
            end

            it 'responds with 200' do
              expect(response).to have_http_status(200)
            end

            it 'responds with js' do
              expect(response.content_type).to eq('text/javascript')
            end
          end
        end

        context 'with invalid attributes' do
          it 'does not update reaction' do
            previous_flagged = reaction.flagged
            put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: invalid_attributes, format: :js }
            expect(reaction.flagged).to eq(previous_flagged)
          end
        end
      end

      context 'when non-member' do
        context 'with valid attributes' do
          it 'does not update campaign' do
            previous_flagged = reaction.flagged
            put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { reaction: valid_attributes, format: :js }
            expect(reaction.flagged).to eq(previous_flagged)
          end

          it 'responds with 302' do
            put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { campaign: valid_attributes, format: :js }
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            put organization_campaign_post_reaction_path(organization, campaign, post, reaction), params: { campaign: valid_attributes, format: :js }
            expect(response).to redirect_to(organizations_url)
          end
        end
      end
    end
  end
end
