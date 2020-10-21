class ChangeDefaultValueOfSecondFactorAttemptCount < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        change_column_default(:users, :second_factor_attempts_count, from: nil, to: 0)
        User.all.each do |u|
          if u.second_factor_attempts_count.nil?
            u.second_factor_attempts_count = 0
            u.save
          end
        end
        change_column_null(:users, :second_factor_attempts_count, false)
      end

      dir.down do
        change_column_null(:users, :second_factor_attempts_count, true)
        User.all.each do |u|
          if u.second_factor_attempts_count.zero?
            u.second_factor_attempts_count = nil
            u.save
          end
        end
        change_column_default(:users, :second_factor_attempts_count, from: 0, to: nil)
      end
    end
  end
end
