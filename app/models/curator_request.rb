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

class CuratorRequest < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :message, presence: true

  def accepted?
    accepted_at.present?
  end

  def rejected?
    rejected_at.present?
  end

  def accept!
    update(accepted_at: Time.now, rejected_at: nil)
    user.update(role: :curator)
  end

  def rejected!
    update(rejected_at: Time.now, accepted_at: nil)
    user.update(role: :registered)
  end
end
