module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end
end
