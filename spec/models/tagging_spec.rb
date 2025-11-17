# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  article_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tag_id     :integer
#  lang       :string
#

require 'rails_helper'

RSpec.describe Tagging, type: :model do

  it "is invalid without tag" do
    article = FactoryBot.create(:article)
    tagging = FactoryBot.build(:tagging, article: article, tag: nil)
    expect(tagging).not_to be_valid
  end

  it "is invalid without article" do
    tag = FactoryBot.create(:tag)
    tagging = FactoryBot.build(:tagging, article: nil, tag: tag)
    expect(tagging).not_to be_valid
  end

  it "is invalid with a duplicate tag on an article." do
    tag = FactoryBot.create(:tag)
    article = FactoryBot.create(:article)
    tagging = FactoryBot.create(:tagging, tag: tag, article: article)
    invalid_tagging = FactoryBot.build(:tagging, tag: tag, article: article)
    expect(invalid_tagging).not_to be_valid
  end

end
