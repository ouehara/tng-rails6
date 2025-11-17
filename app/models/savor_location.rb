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

class SavorLocation < ActiveRecord::Base
  translates :pref, :township, :sub_township
  globalize_accessors :locales => ["en", "zh-hant", "zh-hans", "ja", "th","ko","vi"],
  :attributes => [:pref,:township,:sub_township]
end
