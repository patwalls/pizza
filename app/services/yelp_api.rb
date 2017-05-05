class YelpApi
  def self.get(url)
    response = ::RestClient.get("https://api.yelp.com/v3/#{url}", headers = authorization_header).body
    JSON.parse(response) if response
  end

  def self.authorization_header
    {
      Authorization: 'Bearer LXBxU95wk6kMHAhh1BVvaPETtksWLgaaoGC-jBdspUXJe2eLrSM3iJD3HZ1coKDyUp9zoTgfuP9mOJq_phn_hDX9xBZIyxw4CDMhXPQlUX7T0_3RlWpOr0ooaNYLWXYx'
    }
  end
end
