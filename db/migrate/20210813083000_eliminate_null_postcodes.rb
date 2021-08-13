class EliminateNullPostcodes < ActiveRecord::Migration[6.1]
  def change
    change_column_null :locations, :postcode, false, ""
  end
end
