require 'rails_helper'

RSpec.describe Share, type: :model do
  let(:post) { FactoryGirl.create(:post) }

  describe 'associations' do
    it 'belongs to post' do
      expect(Share.reflect_on_association(:post).macro).to eql(:belongs_to)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: post.id
      )
      share = Share.new(valid_attributes)

      expect(share).to be_valid
    end

    it 'is not valid with missing post' do
      invalid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: nil
      )
      share = Share.new(invalid_attributes)

      expect(share).to_not be_valid
    end

    it 'is not valid with missing network_share_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: post.id,
        network_share_id: nil
      )
      share = Share.new(invalid_attributes)

      expect(share).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: post.id,
        network_user_id: nil
      )
      share = Share.new(invalid_attributes)

      expect(share).to_not be_valid
    end

    it 'is not valid with missing network_user_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: post.id,
        network_user_name: nil
      )
      share = Share.new(invalid_attributes)

      expect(share).to_not be_valid
    end

    it 'is not valid if share with network_share_id already exists within post' do
      FactoryGirl.create(:share, post_id: post.id, network_share_id: '1234')
      invalid_attributes = FactoryGirl.attributes_for(
        :share,
        post_id: post.id,
        network_share_id: '1234'
      )
      share = Share.new(invalid_attributes)

      expect(share).to_not be_valid
    end
  end

  describe 'scope' do
    before(:context) do
      10.times { FactoryGirl.create(:share) }
      4.times { FactoryGirl.create(:share, flagged: true) }
    end

    describe 'flagged' do
      it 'should return only flagged shares' do
        expect(Share.flagged).to eq(Share.where(flagged: true))
        expect(Share.flagged.count).to eql(4)
      end
    end
  end
end
