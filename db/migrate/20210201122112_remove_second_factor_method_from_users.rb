class RemoveSecondFactorMethodFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :second_factor_method, :string
  end
end
