class Organisation < ApplicationRecord
  has_one_attached :signed_mou
  has_and_belongs_to_many :users, inverse_of: :organisation
  has_many :locations, dependent: :destroy
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :service_email, format: { with: Devise.email_regexp, message: "must be a valid email address" }
  validate :validate_in_register?, unless: Proc.new { |org| org.name.blank? }

  def validate_in_register?
    unless Organisation.fetch_organisations_from_register.include?(name)
      errors.add(:base, "#{name} isn't a whitelisted organisation")
    end
  end

  def self.fetch_organisations_from_register
    UseCases::Organisation::FetchOrganisationRegister.new(
      organisations_gateway: Gateways::GovukOrganisationsRegisterGateway.new
    ).execute.sort
  end
end
