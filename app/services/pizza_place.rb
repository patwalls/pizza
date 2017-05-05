class PizzaPlace
  attr_reader :id, :name, :page, :limit, :average_score
  attr_accessor :reviews

  def initialize(options)
    @id = options[:id]
    @limit = options[:limit].to_i
    @name = YelpApi.get("https://api.yelp.com/v3/businesses/little-joes-pizzeria-san-francisco")['name']
    @page = Nokogiri::HTML(open("https://www.yelp.com/biz/#{id}", 'User-Agent' => 'Patty'))
    @reviews = []
  end

  def get_reviews
    @page.css("div.review").each_with_index do |review, idx|
      next if idx == 0
      break if idx > limit
      reviews << create_review_object(review)
    end
    get_average_score
    reviews
  end

  private

  def get_average_score
    @average_score = (reviews.sum(&:rating) / reviews.count)
  end

  def create_review_object(review)
    OpenStruct.new(
      name: get_name(review).strip,
      location: get_location(review).strip,
      rating: get_rating(review),
      review: get_review(review),
      date: get_date(review),
      image: get_img(review)
    )
  end

  def get_name(review)
    review.css(".user-name").text
  end

  def get_location(review)
    review.css(".user-location").text
  end

  def get_rating(review)
    first_node = review.css(".i-stars").first
    BigDecimal(first_node.attributes['title'].value[0..2]) if first_node
  end

  def get_review(review)
    review.css("p").first.try(:text).try(:strip)
  end

  def get_date(review)
    review.css(".rating-qualifier").text.strip
  end

  def get_img(review)
    first_node = review.css('img').first
    first_node.attributes['src'].value if first_node
  end
end
