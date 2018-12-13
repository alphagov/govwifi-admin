class Location < ApplicationRecord
  belongs_to :organisation

  has_many :ips, dependent: :destroy
  accepts_nested_attributes_for :ips

  # When present, this breaks ip_spec.rb:54
  # When absent, this breaks location_spec.rb:42
  # validates_associated :ips

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
