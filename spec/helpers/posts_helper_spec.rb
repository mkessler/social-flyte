require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe '.synced_at_formatted' do
    context 'synced_at date exists' do
      it 'returns the formatted date string' do
        post = FactoryGirl.create(
          :post,
          synced_at: DateTime.new(2017, 1, 1, 10, 15)
        )
        expect(synced_at_formatted(post.synced_at)).to eql('Jan 1, 2017 10:15am UTC')
      end
    end

    context 'synced_at date nil' do
      it 'returns default response' do
        post = FactoryGirl.create(:post, synced_at: nil)
        expect(synced_at_formatted(post.synced_at)).to eql('Never')
      end
    end
  end
end
