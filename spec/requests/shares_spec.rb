require 'rails_helper'

RSpec.describe "Shares", type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user) }
  let(:share) { FactoryGirl.create(:share, post: post) }
  let(:valid_attributes) { {flagged: true} }
  let(:invalid_attributes) { {flagged: "test"} }
  let(:protected_attributes) { {post_id: Faker::Number.number(10)} }

  describe 'GET /posts/:post_id/shares' do
    context 'when logged out' do
      before(:example) do
        get post_shares_path(post, format: :json)
      end

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
        get post_shares_path(post, format: :json)
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'assigns post' do
        expect(assigns(:post)).to be_a(Post)
      end
    end
  end

  describe 'UPDATE /posts/:post_id/share:id' do
    context 'when logged out' do
      it 'does not update share' do
        previous_flagged = share.flagged
        put post_share_path(post, share), params: { share: valid_attributes, format: :js }
        expect(share.flagged).to eq(previous_flagged)
      end

      context 'js request' do
        before(:example) do
          put post_share_path(post, share), params: { share: valid_attributes, format: :js }
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

      context 'with valid attributes' do
        it 'updates share' do
          previous_flagged = share.flagged
          put post_share_path(post, share), params: { share: valid_attributes, format: :js }
          share.reload
          expect(share.flagged).to_not eql(previous_flagged)
        end

        context 'js request' do
          before(:example) do
            put post_share_path(post, share), params: { share: valid_attributes, format: :js }
          end

          it 'assigns post' do
            expect(assigns(:post)).to eql(post)
          end

          it 'assigns share' do
            expect(assigns(:share)).to eql(share)
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
        it 'does not update share' do
          previous_flagged = share.flagged
          put post_share_path(post, share), params: { share: invalid_attributes, format: :js }
          expect(share.flagged).to eq(previous_flagged)
        end
      end
    end
  end
end
