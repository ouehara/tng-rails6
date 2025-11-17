module Admin::TagsHelper

  # Render ancestors with '>'
  # @param [Tag] tag Tag model
  # @return [nil]
  def format_ancestors(tag)
    concat "Root tag." if tag.is_root?

    tag.ancestors.each_with_index do |ancestor, i|
      concat " > " if i > 0
      concat(link_to ancestor.name, [:admin, ancestor])
    end
    nil
  end


end
