class Candlestick < ActiveRecord::Base
  attr_accessible :body_bottom, :body_length, :body_percent, :body_top, :lower_shadow_length, :lower_shadow_percent, :trend, :upper_shadow_length, :upper_shadow_percent
  belongs_to :quote

  validates :trend, presence: true

  BULLISH_TREND = "BULL"
  BEARISH_TREND = "BEAR"
end
