require "uk_postcode"

class Location < ApplicationRecord
  belongs_to :organisation

  has_many :ips, dependent: :destroy
  accepts_nested_attributes_for :ips

  validates_associated :ips

  validates :address, :postcode, presence: true
  validate :validate_postcode_format, if: ->(l) { l.postcode.present? }

  before_create :set_radius_secret_key

  def full_address
    "#{address}, #{postcode}"
  end

  def sorted_ip_addresses
    ips.sort_by { |ip| ip.address.split(".").map(&:to_i) }
  end

  def add_blank_ips(number_to_add)
    remaining = number_to_add - blank_ips.length
    remaining.times { ips.build }
  end

  def blank_ips
    ips.reject(&:persisted?)
  end

  def ips_unable_to_be_persisted
    blank_ips.select(&:address)
  end

private

  def validate_postcode_format
    unless UKPostcode.parse(postcode.to_s).valid?
      errors.add(:postcode, "Postcode must be valid")
    end
  end

  def set_radius_secret_key
    use_case = UseCases::Administrator::GenerateRadiusSecretKey.new
    self.radius_secret_key = use_case.execute
  end
end
