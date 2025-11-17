class TopPageSection < ActiveRecord::Base
    translates :title, :more_btn_text, :active, :more_btn_link, :selected_template, :display
    enum selected_template: [:slider, :grid, :grid_small, :grid_full_width_header_image, :circle]
    has_many :top_page_sections_element 
end
