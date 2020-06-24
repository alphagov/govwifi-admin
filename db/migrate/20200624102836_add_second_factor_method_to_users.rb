class AddSecondFactorMethodToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :second_factor_method, :string
  end
end
