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

end
