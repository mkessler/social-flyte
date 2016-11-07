require 'rails_helper'

RSpec.describe Network, type: :model do
  describe 'associations' do
    it 'has many authentications' do
      expect(Network.reflect_on_association(:authentications).macro).to eql(:has_many)
    end

    it 'has many posts' do
      expect(Network.reflect_on_association(:posts).macro).to eql(:has_many)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      valid_attributes = {name: 'Example', slug: 'example'}
      network = Network.new(valid_attributes)

      expect(network).to be_valid
    end

    it 'is not valid with missing name' do
      invalid_attributes = {name: nil, slug: 'example'}
      network = Network.new(invalid_attributes)

      expect(network).to_not be_valid
    end

    it 'is not valid with missing slug' do
      invalid_attributes = {name: 'Example', slug: nil}
      network = Network.new(invalid_attributes)

      expect(network).to_not be_valid
    end
  end

  describe '.facebook' do
    it 'should return record for facebook' do
      facebook = Network.find_by_slug('facebook')
      expect(Network.facebook).to eql(facebook)
    end
  end

  describe '.twitter' do
    it 'should return record for twitter' do
      twitter = Network.find_by_slug('twitter')
      expect(Network.twitter).to eql(twitter)
    end
  end

  describe '.instagram' do
    it 'should return record for instagram' do
      instagram = Network.find_by_slug('instagram')
      expect(Network.instagram).to eql(instagram)
    end
  end
end
