class AddQuoteIdToCandlestick < ActiveRecord::Migration
  def change
  	add_column :candlesticks, :quote_id, :integer
  end
end
