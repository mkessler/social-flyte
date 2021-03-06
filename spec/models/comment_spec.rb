require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:post) { FactoryGirl.create(:post) }

  describe 'associations' do
    it 'belongs to post' do
      expect(Comment.reflect_on_association(:post).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id
      )
      comment = Comment.new(valid_attributes)

      expect(comment).to be_valid
    end

    it 'is not valid with missing post' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing network_comment_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        network_comment_id: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        network_user_id: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing network_user_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        network_user_name: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing like_count' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        like_count: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing message' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        message: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing posted_at' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        posted_at: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid if comment with network_comment_id already exists within post' do
      FactoryGirl.create(:comment, post_id: post.id, network_comment_id: '1234')
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: post.id,
        network_comment_id: '1234'
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end
  end

  describe 'scope' do
    before(:context) do
      10.times { FactoryGirl.create(:comment) }
      4.times { FactoryGirl.create(:comment, flagged: true) }
    end

    describe 'flagged' do
      it 'should return only flagged comments' do
        expect(Comment.flagged).to eq(Comment.where(flagged: true))
        expect(Comment.flagged.count).to eql(4)
      end
    end
  end
end
