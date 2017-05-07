class YelpReviewScraper
  attr_reader :id, :limit

  def initialize(id, limit)
    @id = id
    @limit = limit
  end

  def scrape
    return unless page = attempt_scrape
    page.css("div.review")[1..limit].map { |review| create_review_object(review) }
  end

  private

  def attempt_scrape
    begin
      parse_xml
    rescue => e
      # we cant access the page or something went wrong
    end
  end

  def parse_xml
    Nokogiri::HTML(open("https://www.yelp.com/biz/#{id}", 'User-Agent' => 'Patty'))
  end

  def create_review_object(review)
    OpenStruct.new(
      name: get_name(review),
      image: get_img(review),
      location: get_location(review),
      date: get_date(review),
      rating: get_rating(review),
      review: get_review(review)
    )
  end

  def get_name(review)
    review.css(".user-name").text.try(:strip)
  end

  def get_img(review)
    first_node = review.css('img').first
    first_node.attributes['src'].value if first_node
  end

  def get_location(review)
    review.css(".user-location").text.try(:strip)
  end

  def get_date(review)
    review.css(".rating-qualifier").text.try(:strip)
  end

  def get_rating(review)
    first_node = review.css(".i-stars").first
    BigDecimal(first_node.attributes['title'].value[0..2]) if first_node
  end

  def get_review(review)
    review.css("p").first.try(:text).try(:strip)
  end
end
