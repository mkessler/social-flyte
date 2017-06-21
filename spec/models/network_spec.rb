require 'rails_helper'

RSpec.describe Network, type: :model do
  describe 'associations' do
    it 'has many posts' do
      expect(Network.reflect_on_association(:posts).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    context 'with valid attributes' do
      it 'is valid' do
        valid_attributes = FactoryGirl.attributes_for(:network, name: 'Example')
        network = Network.new(valid_attributes)

        expect(network).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is not valid' do
        invalid_attributes = FactoryGirl.attributes_for(:network, name: nil)
        network = Network.new(invalid_attributes)

        expect(network).to_not be_valid
      end
    end
  end

  describe '.facebook' do
    it 'returns facebook record' do
      facebook = Network.find_by_slug('facebook')
      expect(Network.facebook).to eql(facebook)
    end
  end

  describe '.set_slug' do
    context 'create' do
      it 'sets slug' do
        network = FactoryGirl.create(:network)
        expect(network.slug).to eql(network.name.parameterize)
        network.destroy
      end
    end
  end

  describe '.user_id' do
    context 'facebook' do
      it 'returns url' do
        network = Network.facebook
        comment = FactoryGirl.create(:comment)
        expect(network.user_link(comment.network_user_id)).to eql("https://facebook.com/#{comment.network_user_id}")
      end
    end
  end
end
