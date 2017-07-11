require 'rails_helper'

RSpec.describe "Invitations", type: :request do
  let(:user) { FactoryGirl.create(:user, id: Faker::Number.number(4)) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:organization_two) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:invitation) { FactoryGirl.create(:invitation, organization: organization, sender_id: user.id) }
  let(:invitation_two) { FactoryGirl.create(:invitation, organization: organization_two, email: Faker::Internet.email, recipient_id: user.id) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:invitation) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:invitation, email: nil) }
  let(:protected_attributes) { { organization_id: Faker::Number.number(2) } }
  let(:update_attributes) { { accepted: true } }
  let(:invalid_update_attributes) { { email: nil } }

  describe 'GET /o/:organization_id/invitations/new' do
    context 'when logged out' do
      before(:example) do
        get new_organization_invitation_path(organization)
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
          get new_organization_invitation_path(organization)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'assigns invitation' do
          expect(assigns(:invitation)).to be_an(Invitation)
        end

        it 'renders new' do
          expect(response).to render_template(:new)
        end
      end

      context 'when non-member' do
        before(:example) do
          get new_organization_invitation_path(organization)
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

  describe 'CREATE /o/:organization_id/invitations' do
    context 'when logged out' do
      it 'does not change Invitation count' do
        expect{
          post organization_invitations_path(organization), params: { invitation: valid_attributes }
        }.to_not change(Invitation, :count)
      end

      context 'html request' do
        before(:example) do
          post organization_invitations_path(organization), params: { invitation: valid_attributes }
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
          post organization_invitations_path(organization), params: { invitation: valid_attributes, format: :json }
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
          it 'increases Invitation count by 1' do
            expect{
              post organization_invitations_path(organization), params: { invitation: valid_attributes }
            }.to change(Invitation, :count).by(1)
          end

          context 'html request' do
            before(:example) do
              post organization_invitations_path(organization), params: { invitation: valid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
            end

            it 'responds with 302' do
              expect(response).to have_http_status(302)
            end

            it 'redirects to organization' do
              expect(response).to redirect_to(organization)
            end
          end

          context 'json request' do
            before(:example) do
              post organization_invitations_path(organization), params: { invitation: valid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
            end

            it 'responds with 201' do
              expect(response).to have_http_status(201)
            end

            it 'responds with json' do
              expect(response.content_type).to eq('application/json')
            end
          end
        end

        context 'with invalid attributes' do
          it 'does not change Invitation count' do
            expect{
              post organization_invitations_path(organization), params: { invitation: invalid_attributes }
            }.to_not change(Invitation, :count)
          end

          context 'html request' do
            before(:example) do
              post organization_invitations_path(organization), params: { invitation: invalid_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
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
              post organization_invitations_path(organization), params: { invitation: invalid_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders invitation errors' do
              expect(response.body).to eq(assigns(:invitation).errors.to_json)
            end
          end
        end

        context 'with protected attributes' do
          it 'does not change invitation count' do
            expect{
              post organization_invitations_path(organization), params: { invitation: protected_attributes }
            }.to_not change(Invitation, :count)
          end

          context 'html request' do
            before(:example) do
              post organization_invitations_path(organization), params: { invitation: protected_attributes }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
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
              post organization_invitations_path(organization), params: { invitation: protected_attributes, format: :json }
            end

            it 'assigns organization' do
              expect(assigns(:organization)).to eql(organization)
            end

            it 'assigns invitation' do
              expect(assigns(:invitation)).to be_an(Invitation)
            end

            it 'responds with 422' do
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              expect(response.body).to eq(assigns(:invitation).errors.to_json)
            end
          end
        end
      end

      context 'when non-member' do
        context 'with valid attributes' do
          it 'does not change Invitation count' do
            expect{
              post organization_invitations_path(organization), params: { invitation: valid_attributes }
            }.to_not change(Invitation, :count)
          end

          it 'responds with 302' do
            post organization_invitations_path(organization), params: { invitation: valid_attributes }
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            post organization_invitations_path(organization), params: { invitation: valid_attributes }
            expect(response).to redirect_to(organizations_url)
          end
        end
      end
    end
  end

  describe 'UPDATE /o/:organization_id/invitations/:id' do
    context 'when logged out' do
      it 'does not update invitation' do
        previous_accepted = invitation_two.accepted
        put organization_invitation_path(organization_two, invitation_two), params: { invitation: invalid_update_attributes }
        expect(invitation_two.accepted).to eq(previous_accepted)
      end

      context 'html request' do
        before(:example) do
          put organization_invitation_path(organization_two, invitation_two), params: { invitation: update_attributes }
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
          put organization_invitation_path(organization_two, invitation_two), params: { invitation: update_attributes, format: :json }
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
        it 'updates invitation' do
          previous_accepted = invitation_two.accepted
          put organization_invitation_path(organization_two, invitation_two), params: { invitation: update_attributes }
          invitation_two.reload
          expect(invitation_two.accepted).to_not eql(previous_accepted)
        end

        context 'html request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: update_attributes }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 302' do
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            expect(response).to redirect_to(organization_url(organization_two))
          end
        end

        context 'json request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: update_attributes, format: :json }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 200' do
            expect(response).to have_http_status(200)
          end

          it 'responds with json' do
            expect(response.content_type).to eq('application/json')
          end
        end
      end

      context 'with invalid attributes' do
        it 'does not update invitation' do
          previous_accepted = invitation_two.accepted
          put organization_invitation_path(organization_two, invitation_two), params: { invitation: invalid_update_attributes }
          expect(invitation_two.accepted).to eq(previous_accepted)
        end

        context 'html request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: invalid_update_attributes }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 302' do
            expect(response).to have_http_status(302)
          end
        end

        context 'json request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: invalid_update_attributes, format: :json }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders invitation errors' do
            expect(response.body).to eq(assigns(:invitation).errors.to_json)
          end
        end
      end

      context 'with protected attributes' do
        it 'does not update invitation' do
          previous_accepted = invitation_two.accepted
          put organization_invitation_path(organization_two, invitation_two), params: { invitation: protected_attributes }
          expect(invitation_two.accepted).to eq(previous_accepted)
        end

        context 'html request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: protected_attributes }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 302' do
            expect(response).to have_http_status(302)
          end
        end

        context 'json request' do
          before(:example) do
            put organization_invitation_path(organization_two, invitation_two), params: { invitation: protected_attributes, format: :json }
          end

          it 'assigns invitation' do
            expect(assigns(:invitation)).to eql(invitation_two)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders organization errors' do
            expect(response.body).to eq(assigns(:invitation).errors.to_json)
          end
        end
      end
    end
  end

  describe 'DESTROY /o/:organization_id/invitations/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          delete organization_invitation_path(organization, invitation)
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
          delete organization_invitation_path(organization, invitation), params: { format: :json }
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
          invitation
        end

        context 'html request' do
          it 'deletes campaign' do
            expect{
              delete organization_invitation_path(organization, invitation)
            }.to change(Invitation, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_invitation_path(organization, invitation)
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_invitation_path(organization, invitation)
            expect(assigns(:invitation)).to eql(invitation)
          end

          it 'responds with 302' do
            delete organization_invitation_path(organization, invitation)
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            delete organization_invitation_path(organization, invitation)
            expect(response).to redirect_to(organization)
          end
        end

        context 'json request' do
          it 'deletes campaign' do
            expect{
              delete organization_invitation_path(organization, invitation), params: { format: :json }
            }.to change(Invitation, :count).by(-1)
          end

          it 'assigns organization' do
            delete organization_invitation_path(organization, invitation), params: { format: :json }
            expect(assigns(:organization)).to eql(organization)
          end

          it 'assigns campaign' do
            delete organization_invitation_path(organization, invitation), params: { format: :json }
            expect(assigns(:invitation)).to eql(invitation)
          end
        end
      end

      context 'when non-member' do
        before(:example) do
          delete organization_invitation_path(organization, invitation)
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
