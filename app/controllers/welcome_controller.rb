class WelcomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index

  end

  def search
    if params[:q].present? == false
      params[:q] = 123
    end
    if params[:r].present? == false
      params[:r] = 123
    end
    if params[:s].present? == false
      params[:s] = 123
    end
    yahoo_client = YahooFinance::Client.new
    #data = yahoo_client.quotes(["AAPL", "AAPL", "AAPL"], [:ask, :symbol])
    data = yahoo_client.quotes(yahoo_client.symbols_by_market('us', 'nyse'), [:ask, :symbol, :pe_ratio, :market_capitalization, :dividend_yield, :high_52_weeks, :low_52_weeks ])
    @dataSymbol = []
    for item in data
      next if item.pe_ratio.present? == false
      next if item.market_capitalization.present? == false
      next if item.dividend_yield.present? == false
      next if item.pe_ratio > params[:r]
      next if item.market_capitalization < params[:q]
      next if item.dividend_yield < params[:s]
      next if item.dividend_yield == "N/A"

      puts item.dividend_yield

      @dataSymbol.push(item)
    end
    #puts @dataSymbol.count
  end

end
