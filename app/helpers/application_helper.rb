module ApplicationHelper
  def field_error(resource, key)
    resource&.errors&.include?(key.to_sym) ? "govuk-form-group--error" : ""
  end

  def active_tab(*identifiers)
    classes = %w[govuk-link govuk-link--no-visited-state]

    classes << "active" if identifiers.any? { |i| request.path.include?(i) }

    classes.join(" ")
  end
end
