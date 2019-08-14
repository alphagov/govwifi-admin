module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end

  def active_tab(identifier)
    classes = %w(govuk-link govuk-link--no-visited-state)

    classes << "active" if request.path.include?(identifier)

    classes.join(" ")
  end
end
