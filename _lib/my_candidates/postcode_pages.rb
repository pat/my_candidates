require 'fileutils'

class MyCandidates::PostcodePages
  def self.call(site = nil)
    new(site).call
  end

  def initialize(site = nil)
    @site = site
  end

  def call
    FileUtils.mkdir_p 'postcodes'

    postcodes.each do |postcode|
      electorates = electorates_for postcode
      next if electorates.length <= 1

      file = File.open "postcodes/#{postcode}.html", 'w'
      file.puts <<-YAML
#{ YAML.dump frontmatter_for(postcode, electorates) }
---
      YAML
    end
  end

  private

  def electorates_for(postcode)
    mappings.keys.select { |key|
      mappings[key].include? postcode
    }
  end

  def frontmatter_for(postcode, electorates)
    {
      'title'       => postcode,
      'layout'      => 'postcodes',
      'electorates' => electorates.collect { |electorate|
        {
          'name' => electorate,
          'path' => "/electorates/#{to_key electorate}.html"
        }
      }
    }
  end

  def mappings
    @mappings ||= JSON.parse File.read("_data/electorates.json")
  end

  def postcodes
    mappings.values.flatten.uniq
  end

  def site
    @site ||= begin
      site = Jekyll::Site.new Jekyll.configuration
      site.process
      site
    end
  end

  def to_key(name)
    name.gsub(/[^\s\w-]+/, '').gsub(/[\s-]+/, '_').downcase
  end
end
