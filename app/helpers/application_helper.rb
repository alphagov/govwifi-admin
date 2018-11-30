module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end

  def active_tab(identifier)
    if (request.path == root_path) && (request.path == identifier)
      return "active"
    elsif request.path.include?(identifier) && identifier != root_path
      return "active"
    else
      ""
    end
  end
end
