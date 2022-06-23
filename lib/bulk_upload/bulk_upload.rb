require "csv"

module BulkUpload
  module BulkUpload

    def self.validate_upload(data, organisation)
      data.each do |row|
        location = organisation.locations.new(address: row[0], postcode: row[1])
        row.slice(2..).each do |ip_address|
          location.ips.new(address: ip_address)
        end
      end
    end

    def self.save_upload(data, organisation)
      validate_upload(data, organisation)
      organisation.save!
    end

    def self.generate_blob_name(organisation_id)
      "uploaded-temp-file-#{organisation_id}-#{Time.zone.now.to_i}.csv"
    end
  end
end
