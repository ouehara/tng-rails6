class Tour < ActiveRecord::Base
    belongs_to :area
    #banner settings
    acts_as_sortable
    has_attached_file :banner,
    styles: {
        regular: '500x500>',
        thumb: '390x260#'
    },
    :s3_protocol => :https,  :default_url => "/assets/articles/default.jpg",
    :path => ':locale/:class/:attachment/:id_partition/:style/:filename',
    processors: [:thumbnail, :paperclip_optimizer],
    :convert_options => {:regular => "-quality 75 -interlace Plane", :thumb => "-quality 75 -interlace Plane"}
    validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/
    #translation fields
    translates :title, :details,:price,:duration, :buttons,:banner_file_name, :banner_file_size, :banner_content_type, :banner_updated_at

    def buttons
        if read_attribute(:buttons, locale: I18n.locale).nil?
            return [Buttons.new({btn: '', link: ''})]
        end

        read_attribute(:buttons, locale: I18n.locale).map {|v|
        Buttons.new(JSON.parse( v.to_json, {:symbolize_names => true} ))
     }
    end

    def buttons_attributes=(attributes)
        buttons = []
        attributes.each do |index, attrs|
            next if '1' == attrs.delete("_destroy")
            buttons << attrs
        end
        if buttons.length == 0
            buttons << Buttons.new({btn: '', link: ''})
        end
        write_attribute(:buttons, buttons)
    end

    def build_buttons
        v = self.buttons.dup
        v << Buttons.new({btn: '', link: ''})
        self.buttons = v
    end

    class Buttons
        attr_accessor :btn, :link
        def persisted?() false; end
        def new_record?() false; end
        def marked_for_destruction?() false; end
        def _destroy() false; end
        def initialize(hash)
            @btn   = hash[:btn]
            @link    = hash[:link]
        end
    end
end
