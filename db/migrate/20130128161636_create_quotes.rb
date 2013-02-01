class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.float :open
      t.float :high
      t.float :low
      t.float :close
      t.datetime :datetime
      t.float :volume
      t.integer :security_id

      t.timestamps
    end
  end
end
