require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe "scope" do
    before(:example) do
      2.times { FactoryGirl.create(:reaction, category: "ANGRY") }
      4.times { FactoryGirl.create(:reaction, category: "HAHA") }
      6.times { FactoryGirl.create(:reaction, category: "LIKE") }
      8.times { FactoryGirl.create(:reaction, category: "LOVE") }
      10.times { FactoryGirl.create(:reaction, category: "SAD") }
      12.times { FactoryGirl.create(:reaction, category: "WOW") }
    end

    describe "angry" do
      it "should return only angry reactions" do
        expect(Reaction.angry).to eq(Reaction.where(category: "ANGRY"))
        expect(Reaction.angry.count).to eql(2)
      end
    end

    describe "haha" do
      it "should return only haha reactions" do
        expect(Reaction.haha).to eq(Reaction.where(category: "HAHA"))
        expect(Reaction.haha.count).to eql(4)
      end
    end

    describe "like" do
      it "should return only like reactions" do
        expect(Reaction.like).to eq(Reaction.where(category: "LIKE"))
        expect(Reaction.like.count).to eql(6)
      end
    end

    describe "love" do
      it "should return only love reactions" do
        expect(Reaction.love).to eq(Reaction.where(category: "LOVE"))
        expect(Reaction.love.count).to eql(8)
      end
    end

    describe "sad" do
      it "should return only sad reactions" do
        expect(Reaction.sad).to eq(Reaction.where(category: "SAD"))
        expect(Reaction.sad.count).to eql(10)
      end
    end

    describe "wow" do
      it "should return only wow reactions" do
        expect(Reaction.wow).to eq(Reaction.where(category: "WOW"))
        expect(Reaction.wow.count).to eql(12)
      end
    end
  end
end
