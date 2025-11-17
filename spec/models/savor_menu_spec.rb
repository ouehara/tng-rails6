# == Schema Information
#
# Table name: savor_menus
#
#  id                  :integer          not null, primary key
#  savor_restaurant_id :integer
#  menu_code           :string
#  menu_type           :integer
#  carry_page          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe SavorMenu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
