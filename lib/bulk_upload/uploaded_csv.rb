module BulkUpload
  class UploadedCsv
    attr_accessor :data, :error_message

    def initialize(file_path, current_organisation)
      @file_path = file_path
      @current_organisation = current_organisation
      @data = nil
      @error_message = nil
      read_csv
      validate_data_structure if data
    end

    def read_csv
      @data = CSV.read(@file_path, col_sep: ";")
    rescue TypeError
      @error_message = "Choose a file before uploading"
    rescue CSV::MalformedCSVError, CSV::Parser::InvalidEncoding
      @error_message = "Invalid file type"
    end

    def validate_data_structure
      if data.empty? || data.any? { |row| row.length < 2 }
        @error_message = "Invalid data structure"
      end
    end
  end
end
