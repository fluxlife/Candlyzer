class Quote < ActiveRecord::Base
  attr_accessible :close, :datetime, :high, :low, :open, :security_id, :volume
  belongs_to :security
  has_one :candlestick

  validates :close, :low, :open, :high, numericality: {greater_than_or_equal_to: 0}, presence: true
  validates :datetime, :security_id, presence: true

  validates_associated :security

  scope :between, lambda {|start_date, end_date| where('datetime BETWEEN ? AND ?',start_date, end_date)}
  scope :since, lambda {|start_date| where('datetime >= ?', start_date)}
  scope :year_to_date, where('datetime >= ?', Time.now.beginning_of_year)
  scope :one_year, where('datetime >= ?', 1.year.ago)

  after_save :build_candlestick

  private

	  def build_candlestick
	  	bullish_trend = close > open
	  	range = high-low
	  	self.candlestick = Candlestick.create(
	  		body_bottom: bullish_trend ? open : close,
	  		body_top: bullish_trend ? close : open,
	  		body_length: (close - open).abs,
	  		body_percent: (close-open).abs/range,
	  		lower_shadow_length: (bullish_trend ? open : close) - low,
	  		lower_shadow_percent: ((bullish_trend ? open : close) - low)/range,
	  		trend: bullish_trend ? Candlestick::BULLISH_TREND : Candlestick::BEARISH_TREND,
	  		upper_shadow_length: high - (bullish_trend ? close : open),
	  		upper_shadow_percent: (high - (bullish_trend ? close : open))/range,
	  	)
	  rescue => ex
	  	logger.warn "Error building candlestick."
	  end
end
