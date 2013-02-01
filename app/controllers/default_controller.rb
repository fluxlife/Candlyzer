class DefaultController < ApplicationController
	def index
	end

	def render_chart
		@symbol = params[:security_symbol]
		security = Security.find_or_create_by_symbol @symbol
		security.update_quotes
		quote_data = security.quotes.one_year.order('datetime ASC')
		@quotes = quote_data.collect{|quote|[quote.datetime.to_i * 1000, quote.open, quote.high, quote.low, quote.close]}.to_json
		@volumes = quote_data.collect{|quote|[quote.datetime.to_i * 1000, quote.volume]}
	end
end
