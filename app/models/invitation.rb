class Invitation < ApplicationRecord
  belongs_to :organisation
  belongs_to :user

  before_create :check_permission_level

  validates :permission_level, presence: true

  def check_permission_level
    membership = Membership.find_by(:user, :organisation)

    if membership.permission_level.blank?
      errors.add(:permission_level, "User does not have a permission level set.")
    end
  end
end
