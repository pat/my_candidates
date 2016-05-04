class MyCandidates::ElectorateScraper
  POSTCODES_TABLE_ID   = 'ContentPlaceHolderBody_gridViewLocalities'
  ELECTORATES_TABLE_ID = 'ContentPlaceHolderBody_panelElectorateList'

  def self.call(driver, electorate)
    new(driver, electorate).call
  end

  def initialize(driver, electorate)
    @driver, @electorate = driver, electorate
  end

  def call
    puts "Finding postcodes for #{electorate}..."
    driver.get "http://apps.aec.gov.au/eSearch/LocalitySearchResults.aspx?filter=#{electorate}&filterby=Electorate"
    sleep 1

    load_results_table

    all = postcodes.uniq.sort
    puts all.join(', ')
    all
  end

  private

  attr_reader :driver, :electorate

  def load_results_table
    driver.find_element :id, POSTCODES_TABLE_ID
  rescue Selenium::WebDriver::Error::NoSuchElementError => error
    results = driver.find_element :id, ELECTORATES_TABLE_ID
    results.all(:css, 'td a').detect { |link| link.text == electorate }.click
    sleep 1

    driver.find_element :id, POSTCODES_TABLE_ID
  end

  def next_page?
    next_pages.any?
  end

  def next_page!
    next_pages.first.click
    sleep 1
  end

  def next_pages
    driver.find_elements(
      :xpath, '//tr[@class="pagingLink"]//span/../following-sibling::td/a'
    )
  end

  def postcodes
    current = driver.find_elements(
      :xpath, '//a[contains(@href, "filterby=Postcode")]'
    ).collect(&:text)

    if next_page?
      next_page!
      current + postcodes
    else
      current
    end
  end
end
