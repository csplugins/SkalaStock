class WelcomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index

  end

  def search
    if params[:mktCap].present? == false
      params[:mktCap] = 1000000000
    end
    if params[:dividend].present? == false
      params[:dividend] = 2.5
    end
    if params[:lowPercent].present? == false
      params[:lowPercent] = 20
    end
    yahoo_client = YahooFinance::Client.new
    #data = yahoo_client.quotes(["FRO", "AAPL", "AAPL"], [:ask, :symbol])
    data = yahoo_client.quotes(yahoo_client.symbols_by_market('us', 'nyse'), [:ask, :symbol, :pe_ratio, :market_capitalization, :dividend_yield, :high_52_weeks, :low_52_weeks, :previous_close ])
    @dataSymbol = []
    for item in data
      next if item.market_capitalization == "N/A"
      next if item.dividend_yield == "N/A"
      next if item.pe_ratio == "N/A"
      #next if item.market_capitalization < params[:mktCap]
      #puts item.market_capitalization
      next if item.market_capitalization.to_s !~ /B/
      next if item.dividend_yield.to_f < params[:dividend].to_f
      yearLow = item.low_52_weeks.to_f
      yearHigh = item.high_52_weeks.to_f
      percent = params[:lowPercent].to_f * 0.01
      tenPercentLow = yearHigh - yearLow
      tenPercentLow *= percent.to_f
      tenPercentLow += yearLow
      next if item.previous_close.to_f > tenPercentLow

      @dataSymbol.push(item)
    end
    #puts @dataSymbol.count
  end

end
