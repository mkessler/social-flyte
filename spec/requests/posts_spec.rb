require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  ActiveJob::Base.queue_adapter = :test

  let(:user) { FactoryGirl.create(:user) }
  let(:user_two) { FactoryGirl.create(:user) }
  let(:user_post) { FactoryGirl.create(:post, user: user) }
  let(:facebook_token) { FactoryGirl.create(:facebook_token, user: user) }
  let(:valid_attributes) { FactoryGirl.attributes_for(:post, network_post_id: Faker::Number.number(10)) }
  let(:invalid_attributes) { FactoryGirl.attributes_for(:post, network_post_id: nil) }
  let(:protected_attributes) { { user: user_two } }

  describe 'GET /posts/new' do
    context 'when logged out' do
      before(:example) do
        get new_post_path
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
        get new_post_path
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'assigns post' do
        expect(assigns(:post)).to be_a(Post)
      end

      it 'renders new' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /posts/:id' do
    context 'when logged out' do
      before(:example) do
        get post_path(user_post)
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
        VCR.use_cassette('facebook_get_user_details') do
          facebook_token
        end
        get post_path(user_post)
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'assigns post' do
        expect(assigns(:post)).to eql(user_post)
      end

      it 'renders show' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'CREATE /posts' do
    context 'when logged out' do
      it 'does not change post count' do
        expect{
          post posts_path, params: { post: valid_attributes }
        }.to_not change(Post, :count)
      end

      it 'does not enqueues sync post job' do
        expect {
          post posts_path, params: { post: valid_attributes }
        }.to_not have_enqueued_job(SyncPostJob)
      end

      context 'html request' do
        before(:example) do
          post posts_path, params: { post: valid_attributes }
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
          post posts_path, params: { post: valid_attributes, format: :json }
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
        user_post
        #post network_tokens_set_path, params: { network: 'facebook', token: Faker::Number.number(10), expires_at: 3600, format: :json }
      end

      context 'with valid attributes' do
        it 'increases post count by 1' do
          expect{
            post posts_path, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it 'enqueues sync post job' do
          expect {
            post posts_path, params: { post: valid_attributes }
          }.to have_enqueued_job(SyncPostJob)
        end

        context 'html request' do
          before(:example) do
            post posts_path, params: { post: valid_attributes }
          end

          it 'assigns post' do
            expect(assigns(:post)).to be_a(Post)
          end

          it 'responds with 302' do
            expect(response).to have_http_status(302)
          end

          it 'redirects to post' do
            expect(response).to redirect_to(post_url(assigns(:post)))
          end
        end

        context 'json request' do
          before(:example) do
            post posts_path, params: { post: valid_attributes, format: :json }
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
        it 'does not change post count' do
          expect{
            post posts_path, params: { post: invalid_attributes }
          }.to_not change(Post, :count)
        end

        it 'does not enqueues sync post job' do
          expect {
            post posts_path, params: { post: invalid_attributes }
          }.to_not have_enqueued_job(SyncPostJob)
        end

        context 'html request' do
          before(:example) do
            post posts_path, params: { post: invalid_attributes }
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
            post posts_path, params: { post: invalid_attributes, format: :json }
          end

          it 'assigns post' do
            expect(assigns(:post)).to be_a(Post)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders post errors' do
            expect(response.body).to eq(assigns(:post).errors.to_json)
          end
        end
      end

      context 'with protected attributes' do
        it 'does not change post count' do
          expect{
            post posts_path, params: { post: protected_attributes }
          }.to_not change(Post, :count)
        end

        it 'does not enqueues sync post job' do
          expect {
            post posts_path, params: { post: protected_attributes }
          }.to_not have_enqueued_job(SyncPostJob)
        end

        context 'html request' do
          before(:example) do
            post posts_path, params: { post: protected_attributes }
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
            post posts_path, params: { post: protected_attributes, format: :json }
          end

          it 'assigns post' do
            expect(assigns(:post)).to be_a(Post)
          end

          it 'responds with 422' do
            expect(response).to have_http_status(422)
          end

          it 'renders post errors' do
            expect(response.body).to eq(assigns(:post).errors.to_json)
          end
        end
      end
    end
  end

  describe 'DESTROY /posts/:id' do
    context 'when logged out' do
      context 'html request' do
        before(:example) do
          delete post_path(user_post)
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
          delete post_path(user_post), params: { format: :json }
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
        user_post
      end

      context 'html request' do
        it 'deletes post' do
          expect{
            delete post_path(user_post)
          }.to change(Post, :count).by(-1)
        end

        it 'assigns post' do
          delete post_path(user_post)
          expect(assigns(:post)).to eql(user_post)
        end

        it 'responds with 302' do
          delete post_path(user_post)
          expect(response).to have_http_status(302)
        end

        it 'redirects to index' do
          delete post_path(user_post)
          expect(response).to redirect_to(posts_path)
        end
      end

      context 'json request' do
        it 'deletes post' do
          expect{
            delete post_path(user_post), params: { format: :json }
          }.to change(Post, :count).by(-1)
        end

        it 'assigns post' do
          delete post_path(user_post), params: { format: :json }
          expect(assigns(:post)).to eql(user_post)
        end
      end
    end
  end
end
