class UploadForm
  include ActiveModel::Model
  include ActiveModel::Validations

  validate :validate_reading_csv
  validate :validate_csv

  def validate_reading_csv
    @data ||= CSV.read(upload_file, col_sep: "\t")
  rescue TypeError
    errors.add(:upload_file, :csv_error, message: "Choose a file before uploading")
  rescue CSV::MalformedCSVError, CSV::Parser::InvalidEncoding
    errors.add(:upload_file, :csv_error, message: "Invalid file type")
  end

  def validate_csv
    errors.add(:upload_file, :csv_error, message: "Invalid data structure") unless csv_valid?
  end

  attr_accessor :upload_file, :data

private

  def csv_valid?
    @data.is_a?(Array) &&
      @data.all? { |row| row.is_a? Array } &&
      @data.all? { |row| row.length >= 2 }
  end
end
