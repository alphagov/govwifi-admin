module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key) ? "govuk-form-group--error" : ""
  end
end
