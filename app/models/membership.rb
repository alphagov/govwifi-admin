class Membership < ApplicationRecord
  belongs_to :organisation
  belongs_to :user
  before_create :set_invitation_token

  scope :pending, -> { where(confirmed_at: nil) }

  def can_manage_team_as_admin_with_limitations?
    user.is_super_admin && can_manage_team? && organisation.has_less_than_two_admin_users?
  end

  def confirm!
    touch :confirmed_at
  end

  def set_invitation_token
    self.invitation_token = Devise.friendly_token[0, 20]
  end

  def confirmed?
    !!confirmed_at
  end

  def administrator?
    can_manage_team? && can_manage_locations?
  end

  def manage_locations?
    !can_manage_team? && can_manage_locations?
  end

  def view_only?
    !can_manage_team? && !can_manage_locations?
  end

  def permission_level
    return "administrator" if administrator?
    return "manage_locations" if manage_locations?

    "view_only"
  end
end
