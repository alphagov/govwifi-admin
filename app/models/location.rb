class Location < ApplicationRecord
  belongs_to :organisation

  has_many :ips, dependent: :destroy
  accepts_nested_attributes_for :ips

  validates :address, presence: true

  before_create :set_radius_secret_key

  def full_address
    postcode.blank? ? address : "#{address}, #{postcode}"
  end

private

  def set_radius_secret_key
    self.radius_secret_key = RadiusSecretKeyGenerator.new.execute
  end
end
