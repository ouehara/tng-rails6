module Admin::CategoriesHelper
  def render_menu(menu,selectable) 
    content_tag(:ul, class: "cateogry-list")  do
      menu.each do |item|
        next if selectable && selectable.id == item.id && !item.has_children?
        concat (content_tag(:li) do
          if selectable
            selected = selectable.parent_id == item.id ? true : false 
            concat(tag(:input, type: "radio", value: item.id, name: "category[parent_id]", checked: selected ))
          end
          concat item.name
        end)
        if item.has_children?
          concat (render_menu(item.children,selectable)) 
        end
      end  
    end 
  end
end
