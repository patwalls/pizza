class PizzaPlace
  attr_reader :id, :name, :page, :limit, :average_score, :reviews

  def initialize(options)
    @id = options[:id]
    @limit = options[:limit].to_i
    @name = get_name_from_yelp_api
    @reviews = []
  end

  def get_data
    return unless name
    scrape_and_save_reviews
    calculate_average_score
  end

  private

  def get_name_from_yelp_api
    begin
      YelpApi.get("businesses/#{id}").try(:[], 'name')
    rescue => e
      nil
    end
  end

  def scrape_and_save_reviews
    @page = yelp_page_xml
    page.css("div.review").each_with_index do |review, idx|
      next if idx == 0
      break if idx > limit
      @reviews << create_review_object(review)
    end
  end

  def yelp_page_xml
    Nokogiri::HTML(open("https://www.yelp.com/biz/#{id}", 'User-Agent' => 'Patty'))
  end

  def calculate_average_score
    @average_score = (reviews.sum(&:rating) / reviews.count)
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
    review.css(".user-name").text.strip
  end

  def get_img(review)
    first_node = review.css('img').first
    first_node.attributes['src'].value if first_node
  end

  def get_location(review)
    review.css(".user-location").text.strip
  end

  def get_date(review)
    review.css(".rating-qualifier").text.strip
  end

  def get_rating(review)
    first_node = review.css(".i-stars").first
    BigDecimal(first_node.attributes['title'].value[0..2]) if first_node
  end

  def get_review(review)
    review.css("p").first.try(:text).try(:strip)
  end
end
