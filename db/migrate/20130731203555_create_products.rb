class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :asin

      t.timestamps
    end
  end
end
