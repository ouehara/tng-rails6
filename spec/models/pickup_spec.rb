# == Schema Information
#
# Table name: pickups
#
#  id                 :integer          not null, primary key
#  title              :string
#  content            :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  published_at       :datetime
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

require 'rails_helper'

RSpec.describe Pickup, type: :model do
  let(:invalid_pickup) { FactoryBot.build(:pickup, title: nil, content: nil) }
  let(:pickup){ FactoryBot.build(:pickup) }
  let(:published_pickup){ FactoryBot.build(:pickup, published_at: Time.now) }

  it "is invalid without title." do
    invalid_pickup.valid?
    expect(invalid_pickup.errors[:title]).to include(I18n.t("errors.messages.blank"))
  end

  describe "#publish" do
    it "updates published_at to Time.now" do
      pickup.publish
      expect(pickup.published_at).not_to eq nil
    end
  end

  describe "#unpublish" do
    it "updates published_at to nil" do
      published_pickup.unpublish
      expect(published_pickup.published_at).to eq nil
    end
  end

  describe "#published?" do
    it "returns true when published_at is present." do
      expect(published_pickup.published?).to eq true
    end
    it "returns false when published_at is present." do
      expect(pickup.published?).to eq false
    end
  end

  # Attachment Image
  it { should have_attached_file(:image) }
  it { should validate_attachment_content_type(:image).allowing('image/png', 'image/jpeg').rejecting('text/plain', 'text/xml', 'image/gif') }
  it { should validate_attachment_size(:image).less_than(1.megabytes) }

end
