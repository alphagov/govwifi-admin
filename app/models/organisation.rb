class Organisation < ApplicationRecord
  has_one_attached :signed_mou
  has_many :users, inverse_of: :organisation, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :service_email, presence: true
  before_save :org_in_register?

  def org_in_register?
    unless fetch_organisations_from_register.include?(name)
      errors.add(:name, "#{name} isn't a whitelisted organisation")
    end
  end

  def fetch_organisations_from_register
    Rails.cache.fetch(:register_organisations, expires_in: 5.minutes) do
      gateway = Gateways::OrganisationRegisterGateway.new
      register = UseCases::Organisation::FetchOrganisationRegister.new(organisations_gateway: gateway)
      register.execute
    end
  end
end
