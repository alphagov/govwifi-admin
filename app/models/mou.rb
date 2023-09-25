class Mou < ApplicationRecord
  before_create :set_default_version

  belongs_to :organisation
  
  validates :organisation_name, presence: true
  validates :signed_date, presence: true
  validates :user_name, presence: true
  validates :user_email, presence: true
  validates :version, presence: true
  attribute :signed, :boolean, default: false

  private

  def set_default_version
    # Don't need to set the version explicitly in controller, and it will automatically default to '1.0' if not provided.
    self.version ||= '1.0'
  end
end


