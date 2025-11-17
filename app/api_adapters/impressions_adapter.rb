
class ImpressionsAdapter
    require 'impressions_services_pb'
    @@stub = Proto::Impressions::Stub.new("#{ENV["IMPRESSION_HOST"]}:#{ENV["IMPRESSION_PORT"]}", :this_channel_is_insecure)
    # id, name, url, tags
    def add(lang, type, id)
        begin 
            @@stub.add_view(Proto::AddViewParams.new(Language:lang, ElementType: type, ElementId: id))
        rescue => error
            puts "=========="
            puts error.inspect
        end
       
    end
    
    #Returns the top 20 of the month
    def getMostViewed()
        begin 
            @@stub.get_most_viewed(Proto::Empty.new())
        rescue => error
            puts "=========="
            puts error.inspect
        end
   
    end

  end