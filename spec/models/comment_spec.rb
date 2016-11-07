require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it 'belongs to post' do
      expect(Comment.reflect_on_association(:post).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    before(:each) do
      @post = FactoryGirl.create(:post)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :comment,
        post_id: @post.id
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
        network_comment_id: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        network_user_id: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing network_user_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        network_user_name: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing like_count' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        like_count: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing message' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        message: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end

    it 'is not valid with missing posted_at' do
      invalid_attributes = FactoryGirl.attributes_for(
        :comment,
        posted_at: nil
      )
      comment = Comment.new(invalid_attributes)

      expect(comment).to_not be_valid
    end
  end
end
