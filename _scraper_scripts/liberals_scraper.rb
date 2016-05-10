require 'open-uri'
require 'nokogiri'
require 'csv'

URIs = [
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=0',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=1',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=2',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=3',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=4',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=5',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=6',
  'https://www.liberal.org.au/our-team?field_mp_state_value=All&field_mp_section_type_value=members&field_mp_electorate_value=&page=7'
]

CSV.open("liberals.csv", "wb") do |csv|
  csv << [
    'Name', 'Electorate', 'Party', 'webpage', 'twitter', 'facebook', 'source'
  ]

  URIs.each do |uri|
    document = Nokogiri::HTML open(uri)

    document.css('.member-profile').each do |row|
      name = row.css('h3').text.strip
      description = row.css('p').text.strip
      electorate = description[/(Member|Candidate) for (.+)/, 2]

      node = row.css('.social-links .fa-twitter').first
      twitter = node && node.parent['href']
      node = row.css('.social-links .fa-facebook').first
      facebook = node && node.parent['href']
      node = row.css('.social-links .fa-desktop').first
      webpage = node && node.parent['href']

      csv << [
        name, electorate, 'Liberal Party of Australia',
        webpage, twitter, facebook
      ]
    end
  end
end
