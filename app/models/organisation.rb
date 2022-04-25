class Organisation < ApplicationRecord
  CSV_HEADER = ["Name", "Created At", "MOU Signed", "Locations", "IPs"].freeze
  has_one_attached :signed_mou
  has_many :memberships, inverse_of: :organisation, dependent: :destroy
  has_many :users, through: :memberships, inverse_of: :organisations
  has_many :locations, dependent: :destroy
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :service_email, format: { with: Devise.email_regexp }
  validate :validate_in_register?, unless: proc { |org| org.name.blank? }

  scope :sortable_with_child_counts, lambda { |sort_column, sort_direction|
    select("organisations.*, COUNT(DISTINCT(locations.id)) AS locations_count, COUNT(DISTINCT(ips.id)) AS ips_count")
    .joins("LEFT OUTER JOIN locations ON locations.organisation_id = organisations.id")
    .joins("LEFT OUTER JOIN ips ON ips.location_id = locations.id")
    .joins("LEFT OUTER JOIN active_storage_attachments ON active_storage_attachments.record_id = organisations.id")
    .group("organisations.id, active_storage_attachments.created_at")
    .order("#{sort_column} #{sort_direction}")
  }

  def ip_addresses
    ips.pluck(:address)
  end

  def validate_in_register?
    unless Organisation.fetch_organisations_from_register.include?(name)
      errors.add(:name, "isn't in the organisations allow list")
    end
  end

  def self.fetch_organisations_from_register
    UseCases::Organisation::FetchOrganisationRegister.new(
      organisations_gateway: Gateways::GovukOrganisationsRegisterGateway.new,
    ).execute.sort
  end

  def self.all_as_csv
    CSV.generate do |csv|
      csv << CSV_HEADER
      Organisation.sortable_with_child_counts("name", "asc").each do |o|
        mou_signed_at = o.signed_mou.attached? ? o.signed_mou.attachment.created_at : "-"
        csv << [o.name, o.created_at, mou_signed_at, o.locations_count, o.ips_count]
      end
    end
  end

  def self.service_emails_as_csv
    CSV.generate do |csv|
      csv << ["Service email address", "Org name", "User name", "Created at"]
      Organisation
        .select("organisations.*, users.name AS user_name")
        .joins("LEFT OUTER JOIN users ON users.email = organisations.service_email").each do |o|
        csv << [o.service_email, o.name, o.user_name, o.created_at]
      end
    end
  end
end
