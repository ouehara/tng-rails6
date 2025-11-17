# == Schema Information
#
# Table name: savor_locations
#
#  id                :integer          not null, primary key
#  pref_code         :string
#  township_code     :string
#  sub_township_code :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe SavorLocation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
