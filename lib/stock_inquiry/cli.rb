class StockInquiry::CLI
  attr_reader :ticker, :ticker_list

  def initialize
    @ticker_list = File.readlines("./lib/stock_inquiry/stock_ticker_092017.txt").map { |ticker| ticker.chomp }.sort
  end

  def start
    obtain_ticker
    valid_ticker?
  end

  def obtain_ticker
    puts "Please enter stock/security ticker symbol"
    @ticker = gets.upcase.strip
  end

  def valid_ticker?
    match_ticker = ticker_list.select { |stock| stock == "#{ticker}" }
    if match_ticker == []
      puts "This is not a valid ticker"
      obtain_ticker
    end
  end
end
