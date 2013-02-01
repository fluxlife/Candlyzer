class CreateSecurities < ActiveRecord::Migration
  def change
    create_table :securities do |t|
      t.integer :exchange_id
      t.string :company_name
      t.string :symbol

      t.timestamps
    end
  end
end
