class RemoveNullFalseConstraint < ActiveRecord::Migration[5.2]
  def change
    change_column_null :memberships, :invitation_token, true
    change_column_null :memberships, :invited_by_id, true
  end
end
