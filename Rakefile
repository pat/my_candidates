task :environment do
  require 'bundler'

  Bundler.setup :default

  $LOAD_PATH.push File.join(__dir__, '_lib')
  require 'my_candidates'
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
