class PizzaPlaceController < ApplicationController
  def search
    query = params[:q] || 'pizza'
    options = { location: 'new york', category: 'pizza' }
    @results = ::YelpApi.biz_search(query, options)
  end

  def show
    @pizza_place = ::PizzaPlace.new(id: params[:id], limit: review_limit)
    @pizza_place.get_data
    render 'error' if api_or_scraping_error?
  end

  private

  def api_or_scraping_error?
     @pizza_place.yelp_metadata.nil? || @pizza_place.reviews.nil?
  end

  def review_limit
    params[:review].try(:[], :limit) ? params[:review][:limit] : 9
  end
end
