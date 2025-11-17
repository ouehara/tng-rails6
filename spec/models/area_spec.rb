# == Schema Information
#
# Table name: areas
#
#  id                :integer          not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  ancestry          :string
#  slug              :string
#  in_sidebar        :boolean
#  area_code         :integer
#  prefecture_code   :integer
#  names_depth_cache :string
#  pos               :integer
#  map_position      :integer
#

require 'rails_helper'

RSpec.describe Area, type: :model do

  it "is invalid without name" do
    area = FactoryBot.build(:area, name: nil)
    expect(area).not_to be_valid
  end

  describe "associated articles." do
    context "when has many articles" do
      it "returns articles." do
        area = FactoryBot.create(:area)
        article_count = 10
        article_array = []
        article_count.times do |i|
          article_array << FactoryBot.create(:article, area: area)
        end
        expect(area.articles).to match_array article_array
      end
    end
    context "when has no articles" do
      it "returns an　empty array." do
        area = FactoryBot.create(:area)
        expect(area.articles).to match_array []
      end
    end
  end
  describe "tree model association" do
    it "has many children." do
      area = FactoryBot.create(:area)
      area2 = FactoryBot.create(:area, parent: area)
      area3 = FactoryBot.create(:area, parent: area)
      expect(area.children).to match_array [area2, area3]
    end

    it "is invalid without a root ancestry." do
      area = FactoryBot.create(:area)
      area2 = FactoryBot.create(:area, parent: area)
      area.reload
      area2.reload
      area.parent = area2
      expect(area).not_to be_valid
    end
  end
end
