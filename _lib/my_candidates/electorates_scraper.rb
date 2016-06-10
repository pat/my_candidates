class MyCandidates::ElectoratesScraper
  def self.call
    new.call
  end

  def call
    electorates.inject({}) do |hash, electorate|
      hash[electorate] = {
        'state'     => state_for(electorate),
        'postcodes' => MyCandidates::ElectorateScraper.call(driver, electorate)
      }
      hash
    end
  end

  private

  def document
    Nokogiri::HTML open("http://www.aec.gov.au/profiles/")
  end

  def driver
    @driver ||= Selenium::WebDriver.for :firefox
  end

  def electorates
    document.css('.division').collect(&:text)
  end

  def state_for(electorate)
    slug = electorate.downcase.gsub(/\s+/, '-').gsub("'", '')

    driver.get "http://www.aec.gov.au/#{slug}"
    driver.find_elements(:xpath, '//dd').first.text
  end
end
