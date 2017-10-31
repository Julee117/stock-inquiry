class StockInquiry::Scrape
  attr_accessor :stock
  attr_reader :doc, :doc_description

  def initialize(ticker)
    @stock = Stock.new
    @stock.ticker = ticker
    @doc = Nokogiri::HTML(open("https://www.reuters.com/finance/stocks/overview/{ticker}"))
    @doc_description = Nokogiri::HTML(open("https://www.reuters.com/finance/stocks/company-profile/#{ticker}"))
  end

  def scrape_name
    @stock.name = @doc.search("#sectionTitle").text.strip
  end

  def scrape_prices
    @doc.search("#headerQuoteContainer").each do |info|
      @stock.current_price = info.search("div.sectionQuote.nasdaqChange div.sectionQuoteDetail span")[1].text.strip
      @stock.previous_close = info.search("div.sectionQuote div.sectionQuoteDetailTop span")[1].text.strip
      @stock.open_price = info.search("div.sectionQuote div:nth-child(2) span")[1].text.strip
      high = info.search("div:nth-child(6) div:nth-child(1) span.sectionQuoteDetailHigh").text.strip
      low = info.search("div:nth-child(6) div:nth-child(2) span.sectionQuoteDetailLow").text.strip
      @stock.range = "#{low} - #{high}"
    end
  end

  def scrape_description
    div = @doc_description.search("#companyNews div.moduleBody")
    div.search("div.moreLink").remove
    @stock.description = div.text.strip
  end
end
