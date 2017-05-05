class PizzaPlaceController < ApplicationController
  def show
    @pizza_place = ::PizzaPlace.new(id: params[:id], limit: review_limit)
    @pizza_place.get_data
  end

  def search
    location = 'new york'
    category_filter = 'pizza'
    search_term = params[:q]
    search_results = ::YelpApi.get("businesses/search?term=#{search_term}&location=#{location}&category_filter=#{category_filter}")
    @results = OpenStruct.new(search_results).businesses
  end

  private

  def api_url

  end

  def review_limit
    params[:review].try(:[], :limit) ? params[:review][:limit] : 9
  end
end
