class Whitelist
  include ActiveModel::Model

  attr_accessor :email_domain, :organisation_name

  def save
    # return false if invalid?

    ActiveRecord::Base.transaction do
      CustomOrganisationName.create(name: organisation_name)
      AuthorisedEmailDomain.create(name: email_domain)
    end

    true
  rescue ActiveRecord::StatementInvalid => e
    # Handle exception that caused the transaction to fail
    # e.message and e.cause.message can be helpful

    errors.add(:base, e.message)

    false
  end
end
