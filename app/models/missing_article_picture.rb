# == Schema Information
#
# Table name: missing_article_pictures
#
#  id         :integer          not null, primary key
#  article_id :integer
#  locale     :string
#  created_at :datetime
#  updated_at :datetime
#

class MissingArticlePicture < ActiveRecord::Base
  belongs_to :article
  scope :filter_lang_not_translated , -> (local = "en") {
    where("is_translated = '{\"#{local}\":\"draft\"}' 
    or is_translated = '{\"#{local}\":\"publish\"}' or 
    is_translated = '{\"#{local}\":\"future\"}'")}
  scope :sort_lang, -> (asc) {
    order("locale #{asc}")
  }
  scope :filter_lang, -> (local="en") {
    where(locale: local)
  }
  scope :sort_status, ->(asc) {
    includes(:articles).order("
    CASE
      WHEN is_translated->>'en' = 'publish' THEN '1'
      WHEN is_translated->>'zh-hant' = 'publish' THEN '2'
      WHEN is_translated->>'zh-hans' = 'publish' THEN '3'
      WHEN is_translated->>'en' = 'draft' THEN '5'
      WHEN is_translated->>'zh-hant' = 'draft' THEN '6'
      WHEN is_translated->>'zh-hans' = 'draft' THEN '7'
    END #{asc}")
  }
end
