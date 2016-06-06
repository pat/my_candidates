require 'nokogiri'
require 'open-uri'
require 'json'
require 'selenium-webdriver'
require 'csv'
require 'jekyll'

module MyCandidates
  REGIONS = {
    'act' => 'Australian Capital Territory',
    'nsw' => 'New South Wales',
    'nt'  => 'Northern Territory',
    'qld' => 'Queensland',
    'sa'  => 'South Australia',
    'tas' => 'Tasmania',
    'vic' => 'Victoria',
    'wa'  => 'Western Australia'
  }
end

require 'my_candidates/additional_candidates'
require 'my_candidates/candidate_data'
require 'my_candidates/candidates_csv'
require 'my_candidates/electorates_scraper'
require 'my_candidates/electorate_scraper'
require 'my_candidates/parties_scraper'

require 'my_candidates/electorate_pages'
require 'my_candidates/postcode_pages'
require 'my_candidates/senate_pages'
