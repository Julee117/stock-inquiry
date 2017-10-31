class StockInquiry::Scrape
  attr_accessor :stock
  attr_reader :doc

  def initialize(ticker)
    @stock = Stock.new
    @stock.ticker = ticker
    @doc = Nokogiri::HTML(open("https://www.reuters.com/finance/stocks/overview/{ticker}"))
  end

  def scrape_name
    @stock.name = @doc.search("#sectionTitle").text.strip
  end
end
