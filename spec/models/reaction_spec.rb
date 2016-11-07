require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe 'validations' do
    before(:each) do
      @post = FactoryGirl.create(:post)
    end

    it 'is valid with valid attributes' do
      valid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id
      )
      reaction = Reaction.new(valid_attributes)

      expect(reaction).to be_valid
    end

    it 'is not valid with missing post' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end

    it 'is not valid with missing network_user_id' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id,
        network_user_id: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end

    it 'is not valid with missing network_user_link' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id,
        network_user_link: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end

    it 'is not valid with missing network_user_name' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id,
        network_user_name: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end

    it 'is not valid with missing network_user_picture' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id,
        network_user_picture: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end

    it 'is not valid with missing category' do
      invalid_attributes = FactoryGirl.attributes_for(
        :reaction,
        post_id: @post.id,
        category: nil
      )
      reaction = Reaction.new(invalid_attributes)

      expect(reaction).to_not be_valid
    end
  end

  describe 'scope' do
    before(:example) do
      2.times { FactoryGirl.create(:reaction, category: 'ANGRY') }
      4.times { FactoryGirl.create(:reaction, category: 'HAHA') }
      6.times { FactoryGirl.create(:reaction, category: 'LIKE') }
      8.times { FactoryGirl.create(:reaction, category: 'LOVE') }
      10.times { FactoryGirl.create(:reaction, category: 'SAD') }
      12.times { FactoryGirl.create(:reaction, category: 'WOW') }
    end

    describe 'angry' do
      it 'should return only angry reactions' do
        expect(Reaction.angry).to eq(Reaction.where(category: 'ANGRY'))
        expect(Reaction.angry.count).to eql(2)
      end
    end

    describe 'haha' do
      it 'should return only haha reactions' do
        expect(Reaction.haha).to eq(Reaction.where(category: 'HAHA'))
        expect(Reaction.haha.count).to eql(4)
      end
    end

    describe 'like' do
      it 'should return only like reactions' do
        expect(Reaction.like).to eq(Reaction.where(category: 'LIKE'))
        expect(Reaction.like.count).to eql(6)
      end
    end

    describe 'love' do
      it 'should return only love reactions' do
        expect(Reaction.love).to eq(Reaction.where(category: 'LOVE'))
        expect(Reaction.love.count).to eql(8)
      end
    end

    describe 'sad' do
      it 'should return only sad reactions' do
        expect(Reaction.sad).to eq(Reaction.where(category: 'SAD'))
        expect(Reaction.sad.count).to eql(10)
      end
    end

    describe 'wow' do
      it 'should return only wow reactions' do
        expect(Reaction.wow).to eq(Reaction.where(category: 'WOW'))
        expect(Reaction.wow.count).to eql(12)
      end
    end
  end
end
