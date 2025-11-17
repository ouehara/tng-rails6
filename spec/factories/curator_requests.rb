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

FactoryBot.define do
  factory :curator_request do
    user nil
    rejected_at {"2016-08-26 15:45:51"}
    accepted_at {"2016-08-26 15:45:51"}
    message {"MyText"}
  end
end
