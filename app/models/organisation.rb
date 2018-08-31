class Organisation < ApplicationRecord
  has_many :users, inverse_of: :organisation
  has_many :ips

  validates :name, presence: true, uniqueness: true

  before_create :set_radius_secret_key

private

  def set_radius_secret_key
    self.radius_secret_key = RadiusSecretKeyGenerator.new.execute
  end
end
