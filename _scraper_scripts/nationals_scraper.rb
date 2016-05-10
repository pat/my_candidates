require 'open-uri'
require 'nokogiri'
require 'csv'

CANDIDATES_URI = 'http://nationals.org.au/our-team/'

document = Nokogiri::HTML open(CANDIDATES_URI)

CSV.open("nationals.csv", "wb") do |csv|
  csv << [
    'Name', 'Electorate', 'Party', 'webpage', 'twitter', 'facebook', 'source'
  ]

  document.css('.nationals_team_members_cat-sitting-members .post-entry').each do |row|
    name = row.css('h2').text.gsub('The Hon.', '').gsub('Mr ', '').gsub('Dr ', '').gsub(' MP', '').gsub('Ms ', '').strip
    title = row.css('.job-titles-list li').detect { |li|
      li.text['Federal Member for']
    }
    next if title.nil?
    electorate = title.text.gsub('Federal Member for', '').strip

    node = row.css('.social-list .fa-twitter').first
    twitter = node && node.parent['href']
    node = row.css('.social-list .fa-facebook').first
    facebook = node && node.parent['href']
    node = row.css('.row .text-block').first.children.detect { |child| child.name == 'a' }
    webpage = node && node['href']

    csv << [
      name, electorate, 'National Party of Australia',
      webpage, twitter, facebook
    ]
  end
end
