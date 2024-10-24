class UserMembershipForm
  include ActiveModel::Model

  attr_accessor :name, :service_email, :organisation_name, :confirmation_token, :password, :user

  validates :user, presence: true
  validate :user_is_valid
  validate :user_is_confirmed

  def save!
    user.save!
    user.confirm
    user.default_membership.confirm!
  end

private

  def user_is_confirmed
    errors.add(:invalid, "The user already been confirmed") if user.confirmed?
  end

  def user_is_valid
    user.assign_attributes(name:, password:)
    user.organisations.build(name: organisation_name, service_email:)
    user.validate

    attribute_transform_map = {
      "organisations.service_email": :service_email,
      "organisations.name": :organisation_name,
    }
    user.errors.each do |error|
      attribute = attribute_transform_map[error.attribute] || error.attribute
      errors.add(attribute, error.message)
    end
  end
end
