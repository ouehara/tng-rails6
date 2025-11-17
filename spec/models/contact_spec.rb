# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  email      :string
#

require 'rails_helper'

RSpec.describe Contact, type: :model do

  let(:invalid_contact) { FactoryBot::build(:contact, name: nil, title: nil, content: nil, email: nil)}
  let(:valid_contact) { FactoryBot::build(:contact)}

  it "is invalid without email." do
    invalid_contact.valid?
    expect(invalid_contact.errors[:email]).to include(I18n.t("errors.messages.blank"))
  end
  it "is invalid without name." do
    invalid_contact.valid?
    expect(invalid_contact.errors[:name]).to include(I18n.t("errors.messages.blank"))
  end
  it "is invalid without title." do
    invalid_contact.valid?
    expect(invalid_contact.errors[:title]).to include(I18n.t("errors.messages.blank"))
  end
  it "is invalid without content." do
    invalid_contact.valid?
    expect(invalid_contact.errors[:content]).to include(I18n.t("errors.messages.blank"))
  end
  it "is valid with name, title and content." do
    expect(valid_contact).to be_valid
  end
end
