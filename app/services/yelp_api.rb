class YelpApi
  def self.biz_search(query, options = {})
    search_path = "businesses/search?term=#{query}"
    search_path += "&location=#{options[:location]}" if options[:location]
    search_path += "&category_filter=#{options[:category]}" if options[:category]

    response = get(search_path)
    OpenStruct.new(response).businesses if response
  end

  def self.business(id)
    response = get("businesses/#{id}")
    OpenStruct.new(response) if response
  end

  def self.get(url)
    begin
      response = ::RestClient.get("https://api.yelp.com/v3/#{url}", headers = authorization_header)
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
    JSON.parse(response.body) unless e
  end

  def self.authorization_header
    {
      Authorization: 'Bearer LXBxU95wk6kMHAhh1BVvaPETtksWLgaaoGC-jBdspUXJe2eLrSM3iJD3HZ1coKDyUp9zoTgfuP9mOJq_phn_hDX9xBZIyxw4CDMhXPQlUX7T0_3RlWpOr0ooaNYLWXYx'
    }
  end
end
