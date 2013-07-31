class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.float :price

      t.timestamps
    end
  end
end
