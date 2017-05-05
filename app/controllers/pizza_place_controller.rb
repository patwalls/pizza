class PizzaPlaceController < ApplicationController
  def show
    @pizza_place = ::PizzaPlace.new(id: params[:id], limit: review_limit)
    @pizza_place_reviews = @pizza_place.get_reviews
  end

  def search
    location = 'new york'
    category_filter = 'pizza'
    search_term = params[:q]
    result = ::YelpApi.get("https://api.yelp.com/v3/businesses/search?term=#{search_term}&location=#{location}&category_filter=#{category_filter}")
    @results = OpenStruct.new(result).businesses.first(10)
  end

  private

  def review_limit
    params[:review] && params[:review][:limit] ? params[:review][:limit] : 10
  end
end
