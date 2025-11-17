class Partner < ActiveRecord::Base
    #banner settings
    acts_as_sortable
    has_attached_file :banner, 
    styles: {
        regular: '500x500>',
        thumb: '160x120#'
    },
    :s3_protocol => :https,  :default_url => "/assets/articles/default.jpg", 
    url: ':s3_alias_url',
    :path => ':locale/:class/:attachment/:id_partition/:style/:filename',
    processors: [:thumbnail, :paperclip_optimizer],
    :convert_options => {:regular => "-quality 90 -interlace Plane", :thumb => "-quality 90 -interlace Plane"}
    validates_attachment_content_type :banner, :content_type => /\Aimage\/.*\Z/
    #translation fields
    translates :title, :link, :banner_file_name, :banner_file_size, :banner_content_type, :banner_updated_at
end
