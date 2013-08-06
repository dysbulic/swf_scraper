class AddProductToRecords < ActiveRecord::Migration
  def change
    add_column :records, :product_id, :integer
  end
end
