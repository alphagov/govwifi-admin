class Organisation < ApplicationRecord
  has_one_attached :signed_mou
  has_many :users, inverse_of: :organisation, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :ips, through: :locations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :service_email, presence: true
end
