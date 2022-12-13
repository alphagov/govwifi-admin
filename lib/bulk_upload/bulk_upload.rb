require "csv"

module BulkUpload
  module BulkUpload
    include AddressHeaders

    def self.add_location_data(data, organisation)
      data.each do |row|
        location = organisation.locations.new(address: UploadForm.build_address(row), postcode: row[POSTCODE]&.strip)
        row.slice(IP_ADDRESS..).reject(&:blank?).each do |ip_address|
          location.ips.new(address: ip_address.strip)
        end
      end
    end
  end
end
