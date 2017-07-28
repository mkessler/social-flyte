require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user) }
  let(:comment) { FactoryGirl.create(:comment, post: post) }
  let(:valid_attributes) { {flagged: true} }
  let(:invalid_attributes) { {flagged: "test"} }
  let(:protected_attributes) { {post_id: Faker::Number.number(10)} }

  describe 'GET /posts/:post_id/comments' do
    context 'when logged out' do
      before(:example) do
        get post_comments_path(post, format: :json)
      end

      it 'responds with 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when logged in' do
      before(:example) do
        sign_in(user)
        get post_comments_path(post, format: :json)
      end

      it 'responds with 200' do
        expect(response).to have_http_status(200)
      end

      it 'assigns post' do
        expect(assigns(:post)).to be_a(Post)
      end
    end
  end

  describe 'UPDATE /posts/:post_id/comment:id' do
    context 'when logged out' do
      it 'does not update comment' do
        previous_flagged = comment.flagged
        put post_comment_path(post, comment), params: { comment: valid_attributes, format: :js }
        expect(comment.flagged).to eq(previous_flagged)
      end

      context 'js request' do
        before(:example) do
          put post_comment_path(post, comment), params: { comment: valid_attributes, format: :js }
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
        it 'updates comment' do
          previous_flagged = comment.flagged
          put post_comment_path(post, comment), params: { comment: valid_attributes, format: :js }
          comment.reload
          expect(comment.flagged).to_not eql(previous_flagged)
        end

        context 'js request' do
          before(:example) do
            put post_comment_path(post, comment), params: { comment: valid_attributes, format: :js }
          end

          it 'assigns post' do
            expect(assigns(:post)).to eql(post)
          end

          it 'assigns comment' do
            expect(assigns(:comment)).to eql(comment)
          end

          it 'responds with 200' do
            expect(response).to have_http_status(200)
          end

          it 'responds with js' do
            expect(response.content_type).to eq('text/javascript')
          end
        end

        context 'with invalid attributes' do
          it 'does not update comment' do
            previous_flagged = comment.flagged
            put post_comment_path(post, comment), params: { comment: invalid_attributes, format: :js }
            expect(comment.flagged).to eq(previous_flagged)
          end
        end
      end
    end
  end
end
