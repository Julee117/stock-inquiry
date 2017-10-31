class StockInquiry::CLI
  attr_reader :ticker, :ticker_list

  def initialize
    @ticker_list = File.readlines("./lib/stock_inquiry/stock_ticker_092017.txt").map { |ticker| ticker.chomp }.sort
  end

  def start
    obtain_ticker
    valid_ticker?
    menu
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

  def menu
    input = ""
    while input != "exit"
      puts ""
      puts "#{ticker}"
      puts ""
      puts "Enter CURRENT to see current price"
      puts "Enter OPEN to see open price"
      puts "Enter PREVIOUS to see previous close price"
      puts "Enter RANGE to see 52 week price range from low to high"
      puts "Enter CHART to see historical price chart"
      puts "Enter ARTICLES to see related news articles"
      puts "Enter DESCRIPTION to read about the company"
      puts "Enter MORE if you would like to do further research"
      puts "Enter NEW to research another stock/security"
      puts "Enter EXIT to exit program"

      input = gets.downcase.strip

      case input
      when "current"
        list_current_price
      when "open"
        list_open_price
      when "previous"
        list_previous_price
      when "range"
        list_range
      when "chart"
        show_chart
      when "articles"
        list_articles
      when "description"
        show_description
      when "more"
        more
      when "new"
        restart
      when "exit"
        exit_program
      end
    end
  end
end
