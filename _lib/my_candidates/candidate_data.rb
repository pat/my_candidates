class MyCandidates::CandidateData
  def self.call
    new.call
  end

  def call
    {
      :persons       => candidates.collect(&:person_hash),
      :organizations => parties_to_hashes,
      :memberships   => candidates.collect(&:membership_hash),
      :events        => [],
      :areas         => electorates_to_hashes
    }
  end

  private

  class Candidate
    def initialize(row, name_key, electorate, party)
      @row, @name_key, @electorate, @party = row, name_key, electorate, party
    end

    def membership_hash
      hash = {
        :person_id       => key,
        :organization_id => "electorate/#{electorate}",
        :role            => "candidate"
      }

      hash[:on_behalf_of_id] = "party/#{party}" if party
      hash
    end

    def person_hash
      {
        :id    => key,
        :name  => row[:name],
        :links => links
      }
    end

    private

    attr_reader :row, :name_key, :electorate, :party

    def key
      @key ||= [electorate, party, name_key].join('/')
    end

    def links
      [
        link_for(:twitter), link_for(:facebook), link_for(:webpage),
        link_for(:oa), link_for(:tvfy)
      ].compact
    end

    def link_for(label)
      return nil if row[label].nil? || row[label].strip.length.zero?

      {
        :url  => row[label],
        :note => label.to_s
      }
    end
  end

  def sheet_rows
    @candidates ||= MyCandidates::CandidatesCSV.call
  end

  def candidates
    @candidates ||= sheet_rows.collect do |row|
      Candidate.new row, to_key(row[:name]), electorates[row[:electorate]],
        parties[row[:party]]
    end
  end

  def electorates
    @electorates ||= key_hash(
      json_data('electorates').keys + MyCandidates::REGIONS.values
    )
  end

  def electorates_to_hashes
    electorates.collect do |name, key|
      {
        :id             => "electorate/#{key}",
        :name           => name,
        :classification => "electorate"
      }
    end
  end

  def json_data(name)
    JSON.parse File.read("_data/#{name}.json")
  end

  def key_hash(names)
    names.inject({}) do |hash, name|
      hash[name] = to_key name
      hash
    end
  end

  def parties
    @parties ||= key_hash json_data('parties')
  end

  def parties_to_hashes
    parties.collect do |name, key|
      {
        :id             => "party/#{key}",
        :name           => name,
        :classification => "party"
      }
    end
  end

  def to_key(name)
    name.gsub(/[^\s\w-]+/, '').gsub(/[\s-]+/, '_').downcase
  end
end
