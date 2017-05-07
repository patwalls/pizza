require 'test_helper'

describe YelpApi do
  describe '.biz_search and .business' do
    it '.biz_search results in array of businesses' do
      YelpApi
        .stubs(:get)
        .returns({ businesses: ['Biz 1', 'Biz 2'] })

      results = YelpApi.biz_search('pizza', location: 'New York')
      assert results == ['Biz 1', 'Biz 2']
    end

    it '.business results in business object' do
      YelpApi
        .stubs(:get)
        .returns({ foo: 'bar' })

      results = YelpApi.business('biz-123')
      assert results.foo == 'bar'
    end

    it 'returns nil if something went wrong' do
      YelpApi
        .stubs(:get)
        .returns(nil)

      results = YelpApi.biz_search('pizza', location: 'New York')
      assert_nil results
    end

    it 'returns nil if error is raised' do
      RestClient.expects(:get).raises(RestClient::NotFound)

      results = YelpApi.biz_search('pizza', location: 'New York')
      assert_nil results
    end
  end
end
