require 'test_helper'

describe YelpReviewScraper do
  subject { YelpReviewScraper }

  let(:scraper) { subject.new(id, limit) }
  let(:id) { 'hello-world' }
  let(:limit) { 9 }

  it 'initializes with id and review limit' do
    assert scraper.id == id
    assert scraper.limit == limit
  end

  it 'returns early if exception is raised on trying get xml' do
    scraper.expects(:parse_xml).raises(StandardError)

    results = scraper.scrape
    assert_nil results
  end
end
