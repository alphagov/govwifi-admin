class RemoveNullFalseConstraintFromInvitationTokenOnMemberships < ActiveRecord::Migration[5.2]
  def change
    change_column_null :memberships, :invitation_token, true
    change_column_null :memberships, :invited_by_id, true
    change_column_null :memberships, :confirmed_at, true
  end
end
