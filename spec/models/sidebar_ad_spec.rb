require 'rails_helper'

RSpec.describe SidebarAd, type: :model do
  before(:all) do
    @ad1 = FactoryBot.build(:sidebar_ad)
  end

  it "is valid with valid attributes" do
    expect(@ad1).to be_valid
  end

  it "is invalid without analytics cateogry" do
    ad = FactoryBot.build(:sidebar_ad, analytics_category: "")
    
    expect(ad).not_to be_valid
  end
  it "is invalid without analytics label" do
    ad = FactoryBot.build(:sidebar_ad, analytics_label: "")
    expect(ad).not_to be_valid
  end

  it "is invalid without publish_start" do
    ad = FactoryBot.build(:sidebar_ad, publish_start: nil)
    expect(ad).not_to be_valid
  end

  it "is invalid if url is not an url" do
    @ad1.url = "notanurl"
    expect(@ad1).not_to be_valid
  end

  context 'published ads' do
    it "excludes future publish_start dates" do
      future_ad = FactoryBot.build(:sidebar_ad, :publish_start => Time.now() + 1.day)
      future_ad.save
      expect(SidebarAd.published).not_to include(future_ad)
    end

    it "excludes past publish_end dates" do
      ad = FactoryBot.build(:sidebar_ad, :publish_end => Time.now() - 1.day)
      ad.save
      expect(SidebarAd.published).not_to include(ad)
    end

    it "date.now must be between publish_start and publish_end" do 
      ad = FactoryBot.build(:sidebar_ad, :publish_start => Time.now() - 2.days,
      :publish_end => Time.now() + 1.day)
      ad.save
      expect(SidebarAd.published).to include(ad)
    end
  end
end
