#class Webpacker::Manifest
#    def handle_missing_entry(name)
#        puts "failed"
#    end
#end

module Webpacker::Helper
    def asset_pack_path(name, **options)
        if current_webpacker_instance.config.extract_css? || !stylesheet?(name)
          asset_path(current_webpacker_instance.manifest.lookup!(name), **options)
        end
        rescue
           ""
    end
end