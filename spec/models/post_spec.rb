require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(:post)
      post = Post.new(valid_attributes)

      expect(post).to be_valid
    end

    it 'is valid with valid with missing network_parent_id' do
      valid_attributes = FactoryGirl.attributes_for(
        :post,
        network_parent_id: nil
      )
      post = Post.new(valid_attributes)

      expect(post).to be_valid
    end

    it 'is not valid with missing network' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        network_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end

    it 'is not valid with missing network_post_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :post,
        network_post_id: nil
      )
      post = Post.new(invalid_attributes)

      expect(post).to_not be_valid
    end
  end
end
