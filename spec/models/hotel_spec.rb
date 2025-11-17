# == Schema Information
#
# Table name: hotels
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  image      :string
#

require 'rails_helper'

RSpec.describe Hotel, type: :model do
  it "is invalid without name" do
    area = FactoryBot.build(:hotel, name: nil)
    expect(area).not_to be_valid
  end

  describe "filter by name" do
    before :each do
      @tokyo = FactoryBot.create(:hotel, name: "Tokyo rei hotel")
      @osaka = FactoryBot.create(:hotel, name: "Osaka")
      @kyoto = FactoryBot.create(:hotel, name: "Kyoto")
    end

    context "with matching letters" do
      it "returns a sorted array of results that match" do
        expect(Hotel.by_name_like("tokyo hotel")).to match_array [@tokyo]
      end
    end

    context "with non-matching letters" do
      it "omits results that do not match" do
        expect(Hotel.by_name_like("to")).not_to include @osaka
      end
    end
  end

end
