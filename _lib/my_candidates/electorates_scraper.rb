class MyCandidates::ElectoratesScraper
  def self.call
    new.call
  end

  def call
    electorates.inject({}) do |hash, electorate|
      hash[electorate] = MyCandidates::ElectorateScraper.call driver, electorate
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
end
