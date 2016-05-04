class MyCandidates::PartiesScraper
  def self.call
    new.call
  end

  def call
    document.css('.r-party a').collect &:text
  end

  private

  def document
    Nokogiri::HTML open('http://www.aec.gov.au/Parties_and_Representatives/Party_Registration/Registered_parties/index.htm')
  end
end
