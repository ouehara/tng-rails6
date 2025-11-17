# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ancestry   :string
#  slug       :string
#  position   :integer
#  css_class  :string
#

require 'rails_helper'

RSpec.describe Category, type: :model do

  it "is invalid without name" do
    category = FactoryBot.build(:category, name: nil)
    expect(category).not_to be_valid
  end

  describe "when associated with Articles" do
    it "has many articles." do
      category = FactoryBot.create(:category)
      article1 = FactoryBot.create(:article, category: category)
      article2 = FactoryBot.create(:article, category: category)
      article3 = FactoryBot.create(:article, category: category)
      article4 = FactoryBot.create(:article, category: category)
      article5 = FactoryBot.create(:article, category: category)
      expect(category.articles.count).to eq 5
    end
  end

end
