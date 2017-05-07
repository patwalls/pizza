class PizzaPlace
  attr_reader :id, :limit, :yelp_metadata, :reviews

  def initialize(options)
    @id = options[:id]
    @limit = options[:limit].to_i
  end

  def get_data
    @yelp_metadata = YelpApi.business(id)
    @reviews = YelpReviewScraper.new(id, limit).scrape
  end

  def average_score
    (reviews.sum(&:rating) / reviews.count).round(1)
  end
end
