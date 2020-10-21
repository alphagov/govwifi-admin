class ChangeDefaultValueOfSecondFactorAttemptCount < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column_default(:users, :second_factor_attempts_count, from: nil, to: 0)
        User.update_all(second_factor_attempts_count: 0)
      end

      dir.down do
        change_column_default(:users, :second_factor_attempts_count, from: 0, to: nil)
      end
    end
  end
end
