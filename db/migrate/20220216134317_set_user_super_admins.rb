class SetUserSuperAdmins < ActiveRecord::Migration[6.1]
  def change
    # First, make everyone not a super admin
    User.where(is_super_admin: true).update_all(is_super_admin: false)
    # Then take all the users in the super admin organisation, and
    # make them super admins
    Organisation.super_admins.first&.users&.update_all(is_super_admin: true)
  end
end
