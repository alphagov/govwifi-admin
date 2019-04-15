module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end

  def active_tab(identifier)
    if request.path.include?(identifier) && identifier != root_path
      "active"
    else
      ""
    end
  end
end
