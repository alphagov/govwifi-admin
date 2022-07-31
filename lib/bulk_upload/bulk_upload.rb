require "csv"

module BulkUpload
  module BulkUpload
    def self.add_location_data(data, organisation)
      data.each do |row|
        location = organisation.locations.new(address: row[0], postcode: row[1])
        row.slice(2..).each do |ip_address|
          location.ips.new(address: ip_address)
        end
      end
    end
  end
end
