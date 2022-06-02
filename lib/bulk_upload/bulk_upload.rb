require "csv"
require_relative "./uploaded_csv"

module BulkUpload
  DUPLICATE_ERROR = "address included multiple times in upload".freeze

  def self.create_location(row, organisation_id)
    location = Location.new(address: row[0], postcode: row[1], organisation_id:)
    row.slice(2..).each do |ip_address|
      location.ips << Ip.new(address: ip_address)
    end
    location.valid?
    location
  end

  def self.identify_upload_duplicates(locations, all_uploaded_addresses, all_uploaded_ips)
    locations.each do |location|
      location.errors.add(:address, "Location #{DUPLICATE_ERROR}") if all_uploaded_addresses.count(location[:address]) > 1
      location.ips.each do |ip|
        ip.errors.add(:address, "IP #{DUPLICATE_ERROR}") if all_uploaded_ips.count(ip[:address]) > 1
      end
    end
  end

  def self.create_upload_summary(data, organisation_id)
    all_uploaded_addresses = data.map { |row| row[0] }
    all_uploaded_ips = data.flat_map { |row| row[2..] }
    locations = data.map { |row| create_location(row, organisation_id) }
    identify_upload_duplicates(locations, all_uploaded_addresses, all_uploaded_ips)
    locations
  end

  def self.upload_has_errors?(locations)
    has_errors = false
    locations.each do |location|
      has_errors = true if location.errors.any?
      location.ips.each do |ip|
        has_errors = true if ip.errors.any?
      end
    end
    has_errors
  end

  def self.generate_blob_name(organisation_id)
    "uploaded-temp-file-#{organisation_id}-#{Time.zone.now.to_i}.csv"
  end
end
