require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe 'gravatar_for' do
    context 'default options' do
      it 'returns gravatar image element' do
        user = FactoryGirl.create(:user)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

        expect(gravatar_for(user)).to eql("<img alt=\"#{user.name}\" class=\"gravatar rounded-circle\" src=\"https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&amp;s=74\" />")
      end
    end

    context 'custom size' do
      it 'returns gravatar image element with updated size' do
        user = FactoryGirl.create(:user)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)

        expect(gravatar_for(user, size: 144)).to eql("<img alt=\"#{user.name}\" class=\"gravatar rounded-circle\" src=\"https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&amp;s=144\" />")
      end
    end
  end
end
