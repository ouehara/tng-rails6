# == Schema Information
#
# Table name: pickup_articles
#
#  id         :integer          not null, primary key
#  pickup_id  :integer
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe PickupArticle, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:article){ FactoryBot.create(:article, user: user, published_at: Time.now) }
  let(:pickup) { FactoryBot.create(:pickup) }
  let(:invalid_pickup_article) { FactoryBot.build(:pickup_article, pickup: nil, article: nil) }

  it "is valid without Pickup" do
    invalid_pickup_article.valid?
    expect(invalid_pickup_article.errors[:pickup]).not_to include(I18n.t("errors.messages.blank"))
  end
  it "is invalid without Article" do
    invalid_pickup_article.valid?
    expect(invalid_pickup_article.errors[:article]).to include(I18n.t("errors.messages.blank"))
  end
  it "is invalid with duplicate Pickup and Article." do
    pickup_article = FactoryBot.create(:pickup_article, pickup: pickup, article: article)
    duplicate_pickup_article = FactoryBot.build(:pickup_article, pickup: pickup, article: article)
    duplicate_pickup_article.valid?
    expect(duplicate_pickup_article.errors[:article]).to include(I18n.t("errors.messages.taken"))
  end


end
