class PizzaPlaceController < ApplicationController
  def search
    query = params[:q] || 'pizza'
    options = { location: 'new york', category: 'pizza' }
    @results = ::YelpApi.biz_search(query, options)
  end

  def show
    @pizza_place = ::PizzaPlace.new(id: params[:id], limit: review_limit)
    @pizza_place.get_data
    render 'error' if @pizza_place.yelp_metadata.nil?
  end

  private

  def review_limit
    params[:review].try(:[], :limit) ? params[:review][:limit] : 9
  end
end
