require 'fileutils'

class MyCandidates::SenatePages
  def self.call(site = nil)
    new(site).call
  end

  def initialize(site = nil)
    @site = site
  end

  def call
    FileUtils.mkdir_p 'senate'

    MyCandidates::REGIONS.each do |abbreviation, region|
      file = File.open "senate/#{to_key region}.html", 'w'
      file.puts <<-YAML
#{ YAML.dump frontmatter_for(region, abbreviation) }
---
      YAML
    end

    file = File.open 'senate/index.html', 'w'
    file.puts <<-YAML
#{ YAML.dump summary_frontmatter }
---
    YAML
  end

  private

  def candidates_for(region)
    region_area = popolo['areas'].detect { |area|
      area['name'] == region
    }
    candidates = popolo['memberships'].select { |membership|
      membership['organization_id'] == region_area['id']
    }.collect { |membership|
      person = popolo['persons'].detect { |person|
        membership['person_id'] == person['id']
      }
      party  = popolo['organizations'].detect { |party|
        membership['on_behalf_of_id'] == party['id']
      } || {}

      {
        'name'     => person['name'],
        'party'    => party['name'] || 'Independent',
        'twitter'  => link_for(person, 'twitter'),
        'facebook' => link_for(person, 'facebook'),
        'webpage'  => link_for(person, 'webpage'),
        'tvfy'     => link_for(person, 'tvfy'),
        'oa'       => link_for(person, 'oa')
      }
    }.sort_by { |hash| hash['name'] }

    parties = candidates.collect { |candidate| candidate['party'] }.uniq.sort
    parties.collect { |party|
      {
        'name'       => party,
        'candidates' => candidates.select { |candidate|
          candidate['party'] == party
        }
      }
    }
  end

  def frontmatter_for(region, abbreviation)
    {
      'title'         => region,
      'layout'        => 'senate',
      'redirect_from' => ["/senate/#{abbreviation}.html"],
      'parties'       => candidates_for(region)
    }
  end

  def link_for(person, label)
    link = person['links'].detect { |link|
      link['note'] == label
    }

    link && link['url']
  end

  def popolo
    @popolo ||= JSON.parse File.read("_data/candidates_popolo.json")
  end

  def site
    @site ||= begin
      site = Jekyll::Site.new Jekyll.configuration
      site.process
      site
    end
  end

  def summary_frontmatter
    {
      'title'   => 'Senate',
      'layout'  => 'senate_list',
      'regions' => MyCandidates::REGIONS.values.sort.collect { |region|
        {
          'name' => region,
          'path' => "/senate/#{to_key region}"
        }
      }
    }
  end

  def to_key(name)
    name.gsub(/[^\s\w-]+/, '').gsub(/[\s-]+/, '_').downcase
  end
end
