require 'rails_helper'

RSpec.describe AccountsHelper, type: :helper do
  let(:facebook_token) { FactoryGirl.create(:facebook_token, :with_before_save_callback) }

  describe '.account_user_name' do
    context 'facebook' do
      it 'returns user name when present' do
        VCR.use_cassette('account_helper_facebook') do
          expect(account_user_name(facebook_token)).to eql(facebook_token.network_user_name)
        end
      end

      it 'returns Connected user name when not present' do
        VCR.use_cassette('account_helper_facebook') do
          facebook_token.network_user_name = nil
          expect(account_user_name(facebook_token)).to eql('Connected')
        end
      end
    end

    context 'nil' do
      it 'returns Not Connected' do
        expect(account_user_name).to eql('Not Connected')
      end
    end
  end

  describe '.account_user_image' do
    context 'facebook' do
      it 'returns user name when present' do
        VCR.use_cassette('account_helper_facebook') do
          expect(account_user_image(facebook_token)).to eql(image_tag(facebook_token.network_user_image_url, alt: facebook_token.network_user_name, class: 'rounded-circle img-responsive'))
        end
      end

      it 'returns Connected user name when not present' do
        VCR.use_cassette('account_helper_facebook') do
          facebook_token.network_user_image_url = nil
          expect(account_user_image(facebook_token)).to eql(account_connected_missing_profile_image)
        end
      end
    end

    context 'nil' do
      it 'returns Not Connected' do
        expect(account_user_image).to eql(account_disconnected_missing_profile_image)
      end
    end
  end

  describe '.account_connected_missing_profile_image' do
    it 'returns icon' do
      content_tag(:i, nil, class: 'fa fa-user fa-4x green-text mt-2', aria: { hidden: true })
    end
  end

  describe '.account_disconnected_missing_profile_image' do
    it 'returns icon' do
      content_tag(:i, nil, class: 'fa fa-user fa-4x mt-2', aria: { hidden: true })
    end
  end
end
