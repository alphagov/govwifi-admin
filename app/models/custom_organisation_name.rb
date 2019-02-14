class CustomOrganisationName < ApplicationRecord
  validate :validate_in_register?
  validates :name, presence: true

  def validate_in_register?
    unless Organisation.fetch_organisations_from_register.exclude?(name.strip)
      errors.add(:name, "is already in our register")
    end
  end

  def self.fetch_organisations_from_register
    UseCases::Organisation::FetchOrganisationRegister.new(
      organisations_gateway: Gateways::GovukOrganisationsRegisterGateway.new
    ).execute.sort
  end
end
