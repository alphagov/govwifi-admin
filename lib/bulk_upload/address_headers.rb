module BulkUpload
  module AddressHeaders
    HEADER_COLS = ["Address line 1", "Address line 2", "Address line 3", "City", "County", "Postcode", "IP address"].freeze
    ADDRESS_LINE_1 = 0
    ADDRESS_LINE_2 = 1
    ADDRESS_LINE_3 = 2
    CITY = 3
    COUNTY = 4
    POSTCODE = 5
    IP_ADDRESS = 6
  end
end
