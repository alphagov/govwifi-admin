module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end

  def active_tab(path)
    request.path == path ? "active" : ""
  end
end
