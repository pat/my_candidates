require 'open-uri'
require 'mechanize'
require 'csv'

agent = Mechanize.new
uris  = [
  'http://greens.org.au/candidates/wa',
  'http://nsw.greens.org.au/candidates/nsw',
  'http://greens.org.au/candidates/qld',
  'http://greens.org.au/candidates/sa',
  'http://greens.org.au/candidates/vic',
  'http://greens.org.au/candidates/tas'
]

CSV.open("greens.csv", "wb") do |csv|
  csv << [
    'Name', 'Electorate', 'Party', 'webpage', 'twitter', 'facebook', 'source'
  ]

  uris.each do |uri|
    page = agent.get(uri)
    page.search("#block-system-main .view-content .views-row").each do |row|
      name = row.search('.views-field-title h4 a, .views-field-title h3 a').first.text.strip
      electorate = row.css('.field-name-field-tag-line').text.strip
      next if electorate['Candidate for'].nil? || electorate['Senate'] || electorate['Ward'] || electorate['Council']
      electorate = electorate.gsub('Candidate for', '').strip

      puts "Getting details for #{name}"

      candidate = agent.click page.link_with(:text => /#{name}/)
      webpage   = candidate.uri.to_s
      links     = candidate.search('a').collect { |a| a.attr(:href) }.compact.uniq

      links -= [
        'https://twitter.com/thegreenswa',
        'https://twitter.com/VictorianGreens',
        'https://www.facebook.com/QueenslandGreens/',
        'https://www.facebook.com/GreensWA',
        'https://facebook.com/VictorianGreens',
        'https://twitter.com/greens',
        'https://twitter.com/QldGreens',
        'https://www.facebook.com/QueenslandGreens',
        'https://www.facebook.com/Australian.Greens',
        'http://facebook.com/australian.greens',
        'https://twitter.com/victoriangreens',
        'https://www.facebook.com/VictorianGreens',
        'http://twitter.com/greensnsw',
        'https://twitter.com/greensnsw',
        'https://www.facebook.com/The.Greens.NSW'
      ]

      links.reject! { |link|
        link['https://twitter.com/intent/tweet'] ||
        link['https://www.facebook.com/sharer/sharer.php'] ||
        link['http://l.facebook.com/l.php']
      }

      facebook  = links.detect { |link| link[/facebook\.com/] }
      twitter   = links.detect { |link| link[/twitter\.com/] }

      csv << [
        name, electorate, 'Australian Greens', webpage, twitter, facebook, uri
      ]
    end
  end
end
