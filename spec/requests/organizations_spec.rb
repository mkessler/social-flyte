require 'rails_helper'

RSpec.describe 'Organizations', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:organization) { FactoryGirl.create(:organization) }
  let(:membership) { FactoryGirl.create(:membership, user: user, organization: organization) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:organization) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:organization, name: nil) }
  let(:protected_attributes) { { slug: Faker::Team.creature } }
  let(:update_attributes) { { name: Faker::Company.name } }
  let(:invalid_update_attributes) { { name: nil } }

  describe 'GET /o' do
    context 'when logged out' do
      before(:example) do
        get organizations_path
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
        get organizations_path
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'renders index' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET /o/new' do
    context 'when logged out' do
      before(:example) do
        get new_organization_path
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
        get new_organization_path
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'assigns organization' do
        expect(assigns(:organization)).to be_an(Organization)
      end

      it 'renders new' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /o/:id' do
    context 'when logged out' do
      before(:example) do
        get organization_path(organization)
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
          get organization_path(organization)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'renders show' do
          expect(response).to render_template(:show)
        end
      end

      context 'when non-member' do
        before(:example) do
          get organization_path(organization)
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

  describe 'GET /o/:id/edit' do
    context 'when logged out' do
      before(:example) do
        get edit_organization_path(organization)
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
          get edit_organization_path(organization)
        end

        it 'responds with 200' do
          expect(response).to have_http_status(200)
        end

        it 'assigns organization' do
          expect(assigns(:organization)).to eql(organization)
        end

        it 'renders edit' do
          expect(response).to render_template(:edit)
        end
      end

      context 'when non-member' do
        before(:example) do
          get edit_organization_path(organization)
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

  describe 'CREATE /o' do
    context 'when logged out' do
      it 'does not change Organization count' do
        expect{
          post organizations_path, params: { organization: valid_attributes }
        }.to_not change(Organization, :count)
      end

      context 'html request' do
        before(:example) do
          post organizations_path, params: { organization: valid_attributes }
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
          post organizations_path, params: { organization: valid_attributes, format: :json }
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
        it 'increases organization count by 1' do
          expect{
            post organizations_path, params: { organization: valid_attributes }
          }.to change(Organization, :count).by(1)
        end

        it 'increases membership count by 1' do
          expect{
            post organizations_path, params: { organization: valid_attributes }
          }.to change(Membership, :count).by(1)
        end

        it 'creates user/organization membership' do
          post organizations_path, params: { organization: valid_attributes }
          expect(
            Membership.where(
              user_id: user.id,
              organization_id: assigns(:organization).id
            )
          ).to be_truthy
        end

        context 'html request' do
          before(:example) do
            post organizations_path, params: { organization: valid_attributes }
          end

          it 'responds with 302' do
            expect(response).to have_http_status(302)
          end

          it 'redirects to organization' do
            expect(response).to redirect_to(assigns(:organization))
          end
        end

        context 'json request' do
          before(:example) do
            post organizations_path, params: { organization: valid_attributes, format: :json }
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
        it 'does not change organization count' do
          expect{
            post organizations_path, params: { organization: invalid_attributes }
          }.to_not change(Organization, :count)
        end

        it 'does not change membership count' do
          expect{
            post organizations_path, params: { organization: invalid_attributes }
          }.to_not change(Membership, :count)
        end

        it 'does not create user/organization membership' do
          post organizations_path, params: { organization: invalid_attributes }
          expect(
            Membership.where(
              user_id: user.id,
              organization_id: assigns(:organization).id
            )
          ).to be_empty
        end

        context 'html request' do
          before(:example) do
            post organizations_path, params: { organization: invalid_attributes }
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
            post organizations_path, params: { organization: invalid_attributes, format: :json }
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders organization errors' do
            expect(response.body).to eq(assigns(:organization).errors.to_json)
          end
        end
      end

      context 'with protected attributes' do
        it 'does not change organization count' do
          expect{
            post organizations_path, params: { organization: protected_attributes }
          }.to_not change(Organization, :count)
        end

        it 'does not change membership count' do
          expect{
            post organizations_path, params: { organization: protected_attributes }
          }.to_not change(Membership, :count)
        end

        it 'does not create user/organization membership' do
          post organizations_path, params: { organization: protected_attributes }
          expect(
            Membership.where(
              user_id: user.id,
              organization_id: assigns(:organization).id
            )
          ).to be_empty
        end

        context 'html request' do
          before(:example) do
            post organizations_path, params: { organization: protected_attributes }
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
            post organizations_path, params: { organization: protected_attributes, format: :json }
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders organization errors' do
            expect(response.body).to eq(assigns(:organization).errors.to_json)
          end
        end
      end
    end
  end

  describe 'UPDATE /o/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          put organization_path(organization), params: { organization: update_attributes }
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
          put organization_path(organization), params: { organization: update_attributes, format: :json }
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
          it 'updates organization' do
            previous_name = organization.name
            put organization_path(organization), params: { organization: update_attributes }
            organization.reload
            expect(organization.name).to_not eql(previous_name)
          end

          context 'html request' do
            it 'responds with 302' do
              put organization_path(organization), params: { organization: update_attributes }
              expect(response).to have_http_status(302)
            end

            it 'redirects to organization' do
              put organization_path(organization), params: { organization: update_attributes }
              expect(response).to redirect_to(assigns(:organization))
            end
          end

          context 'json request' do
            it 'responds with 200' do
              put organization_path(organization), params: { organization: update_attributes, format: :json }
              expect(response).to have_http_status(200)
            end

            it 'responds with json' do
              put organization_path(organization), params: { organization: update_attributes, format: :json }
              expect(response.content_type).to eq('application/json')
            end

            it 'renders show' do
              put organization_path(organization), params: { organization: update_attributes, format: :json }
              expect(response).to render_template(:show)
            end
          end
        end

        context 'with invalid attributes' do
          it 'does not update organization' do
            previous_name = organization.name
            put organization_path(organization), params: { organization: invalid_update_attributes }
            expect(organization.name).to eq(previous_name)
          end

          context 'html request' do
            it 'responds with 200' do
              put organization_path(organization), params: { organization: invalid_update_attributes }
              expect(response).to have_http_status(200)
            end

            it 'renders edit' do
              put organization_path(organization), params: { organization: invalid_update_attributes }
              expect(response).to render_template(:edit)
            end
          end

          context 'json request' do
            it 'responds with 422' do
              put organization_path(organization), params: { organization: invalid_update_attributes, format: :json }
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              put organization_path(organization), params: { organization: invalid_update_attributes, format: :json }
              expect(response.body).to eq(assigns(:organization).errors.to_json)
            end
          end
        end

        context 'with protected attributes' do
          it 'does not update organization' do
            previous_name = organization.name
            put organization_path(organization), params: { organization: protected_attributes }
            expect(organization.name).to eq(previous_name)
          end

          context 'html request' do
            it 'responds with 200' do
              put organization_path(organization), params: { organization: protected_attributes }
              expect(response).to have_http_status(200)
            end

            it 'renders edit' do
              put organization_path(organization), params: { organization: protected_attributes }
              expect(response).to render_template(:edit)
            end
          end

          context 'json request' do
            it 'responds with 422' do
              put organization_path(organization), params: { organization: invalid_attributes, format: :json }
              expect(response).to have_http_status(422)
            end

            it 'renders organization errors' do
              put organization_path(organization), params: { organization: invalid_attributes, format: :json }
              expect(response.body).to eq(assigns(:organization).errors.to_json)
            end
          end
        end
      end

      context 'when non-member' do
        before(:example) do
          put organization_path(organization), params: { organization: update_attributes }
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

  describe 'DESTROY /o/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          delete organization_path(organization)
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
          delete organization_path(organization), params: { format: :json }
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

        context 'html request' do
          it 'deletes organization' do
            expect{
              delete organization_path(organization)
            }.to change(Organization, :count).by(-1)
          end

          it 'responds with 302' do
            delete organization_path(organization)
            expect(response).to have_http_status(302)
          end

          it 'redirects to index' do
            delete organization_path(organization)
            expect(response).to redirect_to(organizations_path)
          end
        end

        context 'json request' do
          it 'deletes organization' do
            expect{
              delete organization_path(organization)
            }.to change(Organization, :count).by(-1)
          end
        end
      end

      context 'when non-member' do
        before(:example) do
          delete organization_path(organization)
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
