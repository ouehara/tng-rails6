module Conf
    def getRecommendedArea
        Rails.cache.fetch("recommended-areas",expires_in: 0) do
          file = File.read("#{Rails.root}/public/recommended_area.json")
          JSON.parse(file)
        end
      end
      def getTags
        Rails.cache.fetch("get-tags",expires_in: 0) do
          file = File.read("#{Rails.root}/public/tags.json")
          JSON.parse(file)
        end
      end
      def getRestaurant
        Rails.cache.fetch("get-restaurant",expires_in: 0) do
          file = File.read("#{Rails.root}/public/restaurant.json")
          JSON.parse(file)
        end
      end
      def getTips
        Rails.cache.fetch("get-tips",expires_in: 0) do
          file = File.read("#{Rails.root}/public/tips.json")
          JSON.parse(file)
        end
      end
end