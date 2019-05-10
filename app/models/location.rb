require "uk_postcode"

class Location < ApplicationRecord
  belongs_to :organisation

  has_many :ips, dependent: :destroy
  accepts_nested_attributes_for :ips

  validates_associated :ips

  validates :address, :postcode, presence: true
  validate :validate_postcode

  before_create :set_radius_secret_key

  def full_address
    "#{address}, #{postcode}"
  end

  def self.to_csv
    attributes = %w{service_email}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |location|
        csv << location.attributes.values_at(*attributes)
      end
    end
  end

private

  def validate_postcode
    unless UKPostcode.parse(postcode.to_s).valid?
      errors.add(:postcode, 'must be valid')
    end
  end

  def set_radius_secret_key
    use_case = UseCases::Administrator::GenerateRadiusSecretKey.new
    self.radius_secret_key = use_case.execute
  end
end
