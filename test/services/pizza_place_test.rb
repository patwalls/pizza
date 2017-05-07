require 'test_helper'

describe PizzaPlace do
  subject { PizzaPlace }

  let(:pizza_place) { subject.new(params) }
  let(:params) { { id: 'ray-pizza', limit: 9 } }
  let(:id) { 'ray-pizza' }
  let(:limit) { 9 }
  let(:review_objects) do
    [
      OpenStruct.new(
        name: 'Pat',
        image: '/me.jpg',
        location: 'New York, NY',
        date: '1/1/2017',
        rating: 5.0,
        review: 'Good stuff'
      ),
      OpenStruct.new(
        name: 'Joe',
        image: '/me.jpg',
        location: 'New York, NY',
        date: '1/3/2017',
        rating: 3.0,
        review: 'OK stuff'
      )
    ]
  end

  # stub API call and the scraper
  before do
    YelpApi.stubs(:get).returns({'name' => "Ray's Pizza"})
    YelpReviewScraper
      .any_instance
      .stubs(:scrape)
      .returns(review_objects)
  end

  it 'initializes with id and review limit' do
    assert pizza_place.id == 'ray-pizza'
    assert pizza_place.limit == 9
  end

  it 'saves data from the yelp api' do
    pizza_place.get_data
    assert pizza_place.yelp_metadata.name == "Ray's Pizza"
  end

  it 'saves reviews scraped from the yelp webpage' do
    pizza_place.get_data
    assert pizza_place.reviews.is_a?(Array)
    assert pizza_place.reviews.first.is_a?(OpenStruct)
  end

  it 'calculates average score' do
    pizza_place.get_data
    assert pizza_place.average_score == 4.0
  end
end
