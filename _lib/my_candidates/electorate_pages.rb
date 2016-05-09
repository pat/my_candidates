require 'fileutils'

class MyCandidates::ElectoratePages
  def self.call(site = nil)
    new(site).call
  end

  def initialize(site = nil)
    @site = site
  end

  def call
    FileUtils.mkdir_p 'electorates'

    electorates.each do |electorate|
      file = File.open "electorates/#{to_key electorate}.html", 'w'
      file.puts <<-YAML
#{ YAML.dump frontmatter_for(electorate) }
---
      YAML
    end
  end

  private

  def candidates_for(electorate)
    electorate_area = popolo['areas'].detect { |area|
      area['name'] == electorate
    }
    popolo['memberships'].select { |membership|
      membership['organization_id'] == electorate_area['id']
    }.collect { |membership|
      person = popolo['persons'].detect { |person|
        membership['person_id'] == person['id']
      }
      party  = popolo['organizations'].detect { |party|
        membership['on_behalf_of_id'] == party['id']
      }

      {
        'name'     => person['name'],
        'party'    => party['name'],
        'twitter'  => link_for(person, 'twitter'),
        'facebook' => link_for(person, 'facebook'),
        'webpage'  => link_for(person, 'webpage')
      }
    }
  end

  def electorates
    mappings.keys
  end

  def electorates_for(postcode)
    mappings.keys.select { |key|
      mappings[key].include? postcode
    }
  end

  def frontmatter_for(electorate)
    {
      'title'         => electorate,
      'layout'        => 'electorates',
      'redirect_from' => unique_postcodes_for(electorate).collect { |postcode|
        "/postcodes/#{postcode}.html"
      },
      'candidates'    => candidates_for(electorate)
    }
  end

  def link_for(person, label)
    link = person['links'].detect { |link|
      link['note'] == label
    }

    link && link['url']
  end

  def mappings
    @mappings ||= JSON.parse File.read("_data/electorates.json")
  end

  def popolo
    @popolo ||= JSON.parse File.read("_data/candidates_popolo.json")
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

  def unique_postcodes_for(electorate)
    mappings[electorate].select { |postcode|
      electorates_for(postcode) == [electorate]
    }
  end
end
