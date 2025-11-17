# == Schema Information
#
# Table name: weathers
#
#  id          :integer          not null, primary key
#  degrees     :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location    :string
#  forecast    :jsonb
#

class Weather < ActiveRecord::Base
  after_save :flush_cache
  def self.by_name_like query
    where("lower(location) LIKE ?", "%#{query.downcase}%")
  end
  
  def self.cached_weather query
    Rails.cache.fetch( query.downcase, expires_in: 0) do
      Weather.by_name_like(query).limit(1)
    end
  end

  def flush_cache
    Rails.cache.delete(self.location.downcase)
  end

end
