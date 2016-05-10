require "mechanize"
require "csv"

CANDIDATES_URI = 'http://www.alp.org.au/people/'

agent = Mechanize.new
page  = agent.get(CANDIDATES_URI)

CSV.open("labor.csv", "wb") do |csv|
  csv << [
    'Name', 'Electorate', 'Party', 'webpage', 'twitter', 'facebook', 'source'
  ]

  page.search(
    '.cabinet .grid .mp, .cabinet .grid .candidate, .cabinet .grid .minister'
  ).each do |person|
    name        = person.search('.member-content h2').text.strip
    description = person.search('.member-content p').text.strip
    next if description[/(Member|Candidate) for/].nil?
    electorate  = description.gsub(/(Member|Candidate) for /, '')

    puts "Getting details for #{name}"

    candidate = agent.click person.search('a').first
    links     = candidate.search('a').collect { |a| a.attr(:href) }.compact.uniq

    links -= [
      'https://twitter.com/AustralianLabor',
      'https://www.facebook.com/LaborConnect',
      'https://facebook.com'
    ]

    links.reject! { |link|
      link['https://twitter.com/intent/tweet'] ||
      link['https://www.facebook.com/sharer/sharer.php'] ||
      link['http://l.facebook.com/l.php'] ||
      link['https://twitter.com/search?']
    }

    facebook  = links.detect { |link| link[/facebook\.com/] }
    twitter   = links.detect { |link| link[/twitter\.com/] }
    webpage   = candidate.search('.contact-box a').collect { |a|
      a.attr(:href)
    }.compact.detect { |link|
      link['facebook.com'].nil? && link['twitter.com'].nil? && link[/^http/]
    } || candidate.uri.to_s

    csv << [
      name, electorate, 'Australian Labor Party (ALP)', webpage, twitter,
      facebook, CANDIDATES_URI
    ]
  end
end
