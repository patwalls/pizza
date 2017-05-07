require 'test_helper'

describe PizzaPlaceController do
  describe 'search' do
    let(:expected_result) do
      [
        {
          'id' => 'hello',
          'name' => 'world',
          'categories' => [{'title' => 'Hi'}],
          'location' => {'location' => { 'address1' => 'Hello'}}
        }
      ]
    end

    it 'returns success and with list of businesses' do
      YelpApi
        .stubs(:biz_search)
        .with('rays', { location: 'new york', category: 'pizza' })
        .returns(expected_result)

      get '/', params: {'q' => 'rays'}
      assert_response :success
    end
  end

  describe 'show' do
    it 'returns success and pizza place details and reviews' do
      YelpApi
        .stubs(:business)
        .returns(OpenStruct.new(name: 'hello'))

      YelpReviewScraper
        .any_instance
        .stubs(:scrape)
        .returns(
          [
            OpenStruct.new(
              name: 'test',
              image: '',
              location: 'test',
              date: 'test',
              rating: 5.0,
              review: 'test'
            )
          ]
        )

      get '/rays-pizza'
      assert_response :success
    end
  end
end
