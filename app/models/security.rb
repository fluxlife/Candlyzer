class Security < ActiveRecord::Base
  attr_accessible :company_name, :exchange_id, :symbol
  belongs_to :exchange
  has_many :quotes
  has_many :candlesticks, through: :quote

  validates :symbol, presence: true, uniqueness: true
  after_create :get_exchange_data

  def update_quotes
  	days_ago = 365
  	unless quotes.blank?
  		# days_since_last_update = (Time.now - quotes.last.datetime)/1.day
  		last_quote_date = quotes.order('datetime DESC').first.datetime
  		days_ago = ((Time.now.midnight - last_quote_date.midnight)/1.day)-1
  	end
  	pull_quotes(days_ago) if days_ago >= 1
  end

  def pull_yesterdays_quote
  	pull_quotes(1)
  end

  private
	
	  def get_exchange_data
	  	if exchange.nil?
	  		encoded_yql_query = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.quotes%20where%20symbol%20%3D%20%22#{symbol}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
	  		security_data = JSON.parse(RestClient.get(encoded_yql_query))
	  		yql_error = security_data["query"]["results"]["quote"]["ErrorIndicationreturnedforsymbolchangedinvalid"]
	  		if yql_error.nil?
	  			exchange_name = security_data["query"]["results"]["quote"]["StockExchange"]
	  			self.company_name = security_data["query"]["results"]["quote"]["Name"]
	  			self.exchange_id = Exchange.find_or_create_by_name(exchange_name).id
	  			save
	  		else
	  			errors[:symbol] = "Not a valid Symbol or Symbol not found in Yahoo's database"
	  		end
	  	end
	  rescue => ex
	  	logger.warn "There was an error updating the symbol's exchange information. #{ex}\n#{ex.backtrace}"
	  end

	  def pull_quotes(days_ago)
	  	updated = false
	  	#default time frame - #The earliest you can pull data from is 1.year.ago via the YQL api
	  	start_date = days_ago > 365 ? 1.year.ago : days_ago.days.ago
	  	if start_date < Time.now.midnight #assuming only receiving daily quotes for right now.
	  		end_date = Time.now
				yql_historical_quotes_query = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.historicaldata%20where%20symbol%20%3D%20%22#{symbol}%22%20and%20startDate%20%3D%20%22#{start_date.strftime("%Y-%m-%d")}%22%20and%20endDate%20%3D%20%22#{end_date.strftime("%Y-%m-%d")}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
				response = JSON.parse(RestClient.get(yql_historical_quotes_query))
				response_count = response["query"]["count"]
				if response_count == 0
					errors[:quotes] = "There was an error retrieving quotes for Symbol: #{symbol}"
				elsif response_count == 1
					quote = response["query"]["results"]["quote"]
					Quote.create(
						datetime: Time.parse(quote["Date"]),
						open: quote["Open"].to_f,
						high: quote["High"].to_f,
						low: quote["Low"].to_f,
						close: quote["Close"].to_f,
						volume: quote["Volume"].to_f,
						security_id: id
					)
				else
					response["query"]["results"]["quote"].each do |quote|
						# Quote.create(
						quotes.create(
							datetime: Time.parse(quote["Date"]),
							open: quote["Open"].to_f,
							high: quote["High"].to_f,
							low: quote["Low"].to_f,
							close: quote["Close"].to_f,
							volume: quote["Volume"].to_f
							# ,
							# security_id: id
						)
					end
				end
			else
				errors[:quotes] = "Start Date must be before End Date"
			end
			updated = true
		rescue => ex
			logger.debug "\n\n SENT THIS QUERY: \n #{yql_historical_quotes_query} \n\n\n GOT THIS RESPONSE: \n#{response}"
			logger.warn "There was an error pulling the latest quotes for #{symbol} | #{errors} |- #{ex}\n\n#{ex.backtrace}"
		ensure
			updated
	  end

end
