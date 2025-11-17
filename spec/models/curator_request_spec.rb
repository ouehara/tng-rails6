# == Schema Information
#
# Table name: curator_requests
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  rejected_at :datetime
#  accepted_at :datetime
#  message     :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe CuratorRequest, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:curator_request) { FactoryBot.build(:curator_request, user: user, message: Faker::Lorem.sentence) }
  let(:invalid_request) { FactoryBot.build(:curator_request, user: nil, message: nil) }

  it "is invalid without user" do
    invalid_request.valid?
    expect(invalid_request.errors[:user]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid without message" do
    invalid_request.valid?
    expect(invalid_request.errors[:message]).to include(I18n.t("errors.messages.blank"))
  end

  describe "#accept!" do
    it "update rejected_at to nil and accepted_at to Time.now" do
      curator_request.accept!
      expect(curator_request.accepted?).to eq true
    end
    it "updates requested user to curator." do
      curator_request.accept!
      expect(curator_request.user.curator?).to eq true
    end
  end

  describe "#reject!" do
    it "updates rejected_at to Time.now and accepted_at to nil" do
      curator_request.rejected!
      expect(curator_request.rejected?).to eq true
    end
  end
end
