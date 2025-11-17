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

class SavorLandmark < ActiveRecord::Base
  translates :spot_name, :outline_title, :outline, :access, :address, :spot_photo
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:spot_name,:outline_title,:outline,:access,:address, :spot_photo]
end
