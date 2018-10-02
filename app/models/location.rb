class Location < ApplicationRecord
  belongs_to :organisation
  has_many :ips

  validates :address, presence: true

  before_create :set_radius_secret_key

private

  def set_radius_secret_key
    self.radius_secret_key = RadiusSecretKeyGenerator.new.execute
  end

  def location_address_must_be_valid
    checker = UseCases::Administrator::CheckIfValidLocationAddress.new
    valid_location = checker.execute(self.address)[:success]
    message = 'field cannot be empty'
    errors.add(:address, message) unless valid_location
  end
end
