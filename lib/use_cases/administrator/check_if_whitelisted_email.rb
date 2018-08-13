class CheckIfWhitelistedEmail
  def execute(email)
    return { success: false } if email.blank?

    domain = email.split('@').last
    valid_domain = domain.starts_with?('gov.uk')
    valid_subdomain = domain.include?('.gov.uk')

    { success: valid_domain || valid_subdomain }
  end
end
