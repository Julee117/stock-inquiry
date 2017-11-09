class StockInquiry::Stock
  attr_accessor :name, :ticker, :open_price, :current_price, :previous_close, :range, :description, :articles

  @@all = []

  def initialize
    @articles = []
  end

  def add_article(article)
    articles << article
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def self.find_by_ticker(ticker)
    self.all.detect { |stock| stock.ticker == ticker }
  end
  
  def self.current_price_above(num)
    self.all.select { |stock|  stock.current_price.to_f > num }  
  end
end
