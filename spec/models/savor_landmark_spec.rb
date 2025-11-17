# == Schema Information
#
# Table name: savor_landmarks
#
#  id                :integer          not null, primary key
#  pref_code         :string
#  township_code     :string
#  sub_township_code :string
#  coordinate        :string
#  latitude          :decimal(10, 8)
#  longitude         :decimal(11, 8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe SavorLandmark, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
