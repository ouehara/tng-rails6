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

class Contact < ActiveRecord::Base
  validates :name, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :email, {presence: true,  format: { with: URI::MailTo::EMAIL_REGEXP } }
  
  validates :agreement, acceptance: {accept: true} , on: :create, 
  allow_nil: false
  enum state: {unread: 0, read: 1, answered: 2, ignore: 3, flag_red: 10, flag_orange: 11, flag_yellow: 12, flag_green: 13}
end
