require 'csv'
require 'open-uri'

class MyCandidates::CandidatesCSV
  DOCUMENT_ID = '1PaS7lYTs5pAccFIHImzfStKVFdetjGHuHz54DoOdBP4'
  SHEET_ID    = 0
  SHEET_URI   = "https://docs.google.com/spreadsheets/d/#{DOCUMENT_ID}/export?exportFormat=csv&gid=#{SHEET_ID}"

  def self.call
    CSV.parse open(SHEET_URI).read,
      :headers           => :first_row,
      :header_converters => :symbol
  end
end
