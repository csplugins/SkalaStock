class WelcomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index

  end

  def search
    #render html: '<b>html goes here<b/>'.html_safe
    yahoo_client = YahooFinance::Client.new
    data = yahoo_client.quotes(["AAPL", "AAPL", "AAPL"], [:ask, :symbol])
    @data = data[0].ask
    @dataSymbol = data[0].symbol
  end

end
