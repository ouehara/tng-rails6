class TopPageSectionsElement < ActiveRecord::Base
    translates :title, :link, :image_file_name, :image_file_size, :image_content_type, :image_updated_at, :position
    has_attached_file :image, styles: {
        regular: '500x500>'}, 
        :s3_protocol => :https, 
        :default_url => "/assets/articles/default.jpg",
        url: ':s3_alias_url',
        :path => ':class/:attachment/:id_partition/:style/:filename'
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    belongs_to :top_page_section
    
    acts_as_sortable do |config|
        config[:relation] = -> (instance) {instance.translations}
    end

    def image_url
        
        self.image.url(:original)
    end
end
