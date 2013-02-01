class CreateCandlesticks < ActiveRecord::Migration
  def change
    create_table :candlesticks do |t|
      t.float :upper_shadow_length
      t.float :lower_shadow_length
      t.float :body_length
      t.float :upper_shadow_percent
      t.float :lower_shadow_percent
      t.float :body_percent
      t.float :body_top
      t.float :body_bottom
      t.string :trend

      t.timestamps
    end
  end
end
