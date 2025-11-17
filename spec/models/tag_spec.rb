# == Schema Information
#
# Table name: tags
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ancestry      :string
#  slug          :string
#  article_count :integer
#

require 'rails_helper'

RSpec.describe Tag, type: :model do

  it "is invalid with a duplicate name" do
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.build(:tag, name: tag1.name)
    expect(tag2).not_to be_valid
  end

  it "is invalid with a more than #{Tag::MAX_NAME_LENGTH} letters." do
    tag = FactoryBot.build(:tag, name: Faker::Lorem.characters(Tag::MAX_NAME_LENGTH + 1))
    expect(tag).not_to be_valid
  end

  it "is invalid without a name" do
    tag = FactoryBot.build(:tag, name: nil)
    expect(tag).not_to be_valid
  end

  describe "associated articles." do
    context "when has many articles" do
      it "returns articles." do
        tag = FactoryBot.create(:tag)
        article_count = 10
        article_array = []
        article_count.times do |i|
          article_array << FactoryBot.create(:article, tags: [tag])
        end
        expect(tag.articles).to match_array article_array
      end
    end

    context "when has no articles" do
      it "returns an　empty array." do
        tag = FactoryBot.create(:tag)
        expect(tag.articles).to match_array []
      end
    end
  end
end
