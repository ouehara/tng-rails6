# == Schema Information
#
# Table name: articles
#
#  id                :integer          not null, primary key
#  excerpt           :jsonb
#  contents          :jsonb            not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  category_id       :integer
#  published_at      :datetime
#  impressions_count :integer          default(0)
#  is_translated     :jsonb
#  disp_title        :jsonb
#  area_id           :integer
#  sponsored_content :boolean
#  schedule          :jsonb
#  slug              :string
#  lang_updated_at   :jsonb
#  optimistic_lock   :jsonb            not null
#

require 'rails_helper'

RSpec.describe Article, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:unpublished_article){ FactoryBot.create(:article, user: user) }
  let(:published_article) { FactoryBot.create(:article, user: user, published_at: 10.minutes.ago) }

  it "is valid without user, title, excerpt, contents." do
    expect(FactoryBot.build(:article)).to be_valid
  end

  describe "when user is associated." do
    it "get user(author)." do
      user = FactoryBot.create(:user)
      article = FactoryBot.create(:article, user: user)
      expect(article.user).to eq user
    end
  end

  describe "when belongs to category" do
    it "belongs to category." do
      category = FactoryBot.create(:category)
      article = FactoryBot.create(:article, category: category)
      expect(article.category).to eq category
    end
  end

  describe "taggings" do
    context "when tagged." do
      it "retrieve tags." do
        tag1 = FactoryBot.create(:tag)
        tag2 = FactoryBot.create(:tag)
        article = FactoryBot.create(:article, tags: [tag1, tag2])
        expect(article.tags).to match_array [tag1, tag2]
      end
    end
  end

  describe "#published?" do
    it "returns true when published." do
      expect(published_article.published?).to eq true
    end

    it "returns false when unpublished." do
      expect(unpublished_article.published?).to eq false
    end
  end

  describe "#publish" do
    it "makes the article published." do
      unpublished_article.publish
      expect(unpublished_article.published?).to eq true
    end
  end

  describe "#unpublish" do
    it "makes the article unpublished." do
      published_article.unpublish
      expect(published_article.published?).to eq false
    end
  end

end
