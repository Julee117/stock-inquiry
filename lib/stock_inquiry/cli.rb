class StockInquiry::CLI
  attr_reader :ticker, :ticker_list, :stock

  def initialize
    @ticker_list = File.readlines("./lib/stock_inquiry/stock_ticker_092017.txt").map { |ticker| ticker.chomp }.sort
  end

  def start
    obtain_ticker
    valid_ticker?
    s = StockInquiry::Scraper.new(ticker)
    s.scrape_all
    @stock = StockInquiry::Stock.find_by_ticker(ticker)
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
      puts "#{ticker}:  #{stock.name}"
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

  def list_current_price
    puts ""
    puts @stock.current_price
  end

  def list_open_price
    puts ""
    puts @stock.open_price
  end

  def list_previous_price
    puts ""
    puts @stock.previous_close
  end

  def list_range
    puts ""
    puts @stock.range
  end

  def show_chart
    system("open http://www.reuters.com/finance/stocks/chart/#{ticker}")
  end

  def list_articles
    puts ""
    @stock.articles.each.with_index(1) do |article, idx|
      puts "#{idx}.   #{article.title}"
    end
    if @stock.articles == []
      puts "There are no latest news posted in the site"
      puts "Please enter more to look for further information"
    else
      show_article
    end
  end

  def show_article
    puts "Enter number of the article you would like to read"
    input = gets.to_i

    total_num = @stock.articles.size
    if !input.between?(1, total_num)
      puts "Number not found"
      show_article
    else
      system("open", "https://www.reuters.com#{stock.articles[input - 1].url}")
    end
  end

  def show_description
    puts ""
    puts @stock.description
  end

  def more
    system("open https://www.reuters.com/finance/stocks/overview/#{ticker}")
  end

  def restart
    start
  end

  def exit_program
    puts ""
    puts "Thank you for using stock inquiry"
    exit
  end
end
