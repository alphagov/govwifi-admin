class Organisation < ApplicationRecord
  has_one_attached :signed_mou
  has_many :memberships, inverse_of: :organisation, dependent: :destroy
  has_many :users, through: :memberships, inverse_of: :organisations
  has_many :locations, dependent: :destroy
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :service_email, format: { with: Devise.email_regexp, message: "must be a valid email address" }
  validate :validate_in_register?, unless: Proc.new { |org| org.name.blank? }

  scope :sortable_with_child_counts, ->(sort_column, sort_direction) {
    select("organisations.*, COUNT(DISTINCT(locations.id)) AS locations_count, COUNT(DISTINCT(ips.id)) AS ips_count")
    .joins("LEFT OUTER JOIN locations ON locations.organisation_id = organisations.id")
    .joins("LEFT OUTER JOIN ips ON ips.location_id = locations.id")
    .joins("LEFT OUTER JOIN active_storage_attachments ON active_storage_attachments.record_id = organisations.id")
    .group("organisations.id, active_storage_attachments.created_at")
    .order("#{sort_column} #{sort_direction}")
  }
  scope :super_admins, -> { where(super_admin: true) }

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
