task :environment do
  require 'bundler'

  Bundler.setup :default

  $LOAD_PATH.push File.join(__dir__, '_lib')
  require 'my_candidates'
end

task :rebuild => ['popolo:generate', 'generate:pages']

namespace :generate do
  task :electorate_pages => :environment do
    site = Jekyll::Site.new Jekyll.configuration
    site.process

    MyCandidates::ElectoratePages.call site
  end

  task :postcode_pages => :environment do
    site = Jekyll::Site.new Jekyll.configuration
    site.process

    MyCandidates::PostcodePages.call site
  end

  task :pages => :environment do
    site = Jekyll::Site.new Jekyll.configuration
    site.process

    MyCandidates::PostcodePages.call site
    MyCandidates::ElectoratePages.call site
  end
end

namespace :popolo do
  task :generate => :environment do
    File.write '_data/candidates_popolo.json',
      JSON.pretty_generate(MyCandidates::CandidateData.call)
  end
end

namespace :scrapers do
  desc 'Load electorates and related postcodes from AEC'
  task :electorates => :environment do
    File.write '_data/electorates.json',
      JSON.pretty_generate(MyCandidates::ElectoratesScraper.call)
  end

  desc 'Load political parties from AEC'
  task :parties => :environment do
    File.write '_data/parties.json',
      JSON.pretty_generate(MyCandidates::PartiesScraper.call)
  end
end
