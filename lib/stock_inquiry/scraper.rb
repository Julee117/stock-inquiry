class StockInquiry::Scraper
  attr_accessor :stock
  attr_reader :doc, :doc_description

  def initialize(ticker)
    @stock = StockInquiry::Stock.new
    @stock.ticker = ticker
    @doc = Nokogiri::HTML(open("https://www.reuters.com/finance/stocks/overview/#{ticker}"))
    @doc_description = Nokogiri::HTML(open("https://www.reuters.com/finance/stocks/company-profile/#{ticker}"))
  end

  def scrape_all
    scrape_name
    scrape_prices
    scrape_articles
    scrape_description
    @stock.save
  end

  def scrape_name
    @stock.name = @doc.search("#sectionTitle").text.strip
  end

  def scrape_prices
    @doc.search("#headerQuoteContainer").each do |info|
      price = info.search("div.sectionQuote.nasdaqChange div.sectionQuoteDetail span")[1].text.strip
      currency = info.search("div.sectionQuote.nasdaqChange div.sectionQuoteDetail span")[2].text.strip
      @stock.current_price = "#{price}#{currency}"
      @stock.previous_close = info.search("div.sectionQuote div.sectionQuoteDetailTop span")[1].text.strip
      @stock.open_price = info.search("div.sectionQuote")[2].search("div.sectionQuoteDetail").search("span")[1].text.strip
      high = info.search("div.sectionQuote")[5].search("div.sectionQuoteDetailTop").search("span.sectionQuoteDetailHigh").text.strip
      low = info.search("div.sectionQuote")[5].search("div.sectionQuoteDetail").search("span.sectionQuoteDetailLow").text.strip
      @stock.range = "#{low} - #{high}"
    end
  end

  def scrape_articles
    @doc.search(".moduleBody").each do |section|
      section.search(".feature").each do |article|
        news_article = StockInquiry::Article.new
        news_article.title = article.search("h2").text.strip
        news_article.url = article.search("h2 a").attr('href').text.strip
        @stock.add_article(news_article)
      end
    end
  end

  def scrape_description
    div = @doc_description.search("#companyNews div.moduleBody")
    div.search("div.moreLink").remove
    @stock.description = div.text.strip
  end
end
