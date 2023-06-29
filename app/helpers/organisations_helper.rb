module OrganisationsHelper
  def sort_link(column, title = nil)
    title ||= column.titleize
    
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    
    if column == "name"
      direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    else
      direction = column == sort_column && sort_direction == "desc" ? "asc" : "desc"
    end

    link_to title, { sort: column, direction: direction }, class: css_class
  end
end
