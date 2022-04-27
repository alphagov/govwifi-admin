class CustomOrganisationName < ApplicationRecord
  validate :custom_org_in_register?
  validates :name, presence: true

  def custom_org_in_register?
    if Organisation.fetch_organisations_from_register.include?(name.strip)
      errors.add(:name, "Name is already in our register")
    end
  end
end
