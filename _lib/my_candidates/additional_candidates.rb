class MyCandidates::AdditionalCandidates
  SOURCE = 'https://morph.io/drzax/morph-australian-federal-election-candidates-2016'
  PARTIES = {
    "21CP" => "21st Century Australia",
    "ACP"  => "Australian Country Party",
    "ADVP" => "Australian Defence Veterans Party",
    "AEP"  => "Australian Equality Party (Marriage)",
    "AFN"  => "Australia First Party (NSW) Incorporated",
    "AJP"  => "Animal Justice Party",
    "ALA"  => "Australian Liberty Alliance",
    "ALP"  => "Australian Labor Party (ALP)",
    "AMEP" => "Australian Motoring Enthusiast Party",
    "APP"  => "Australian Antipaedophile Party",
    "ASXP" => "Australian Sex Party",
    "AUC"  => "Australian Christians",
    "CDP"  => "Christian Democratic Party (Fred Nile Group)",
    "CEC"  => "Citizens Electoral Council of Australia",
    "CLP"  => "Country Liberals (Northern Territory)",
    "CM"   => "CountryMinded",
    "DHJ"  => "Derryn Hinch's Justice Party",
    "DLF"  => "Drug Law Reform Australia",
    "DLP"  => "Democratic Labour Party (DLP)",
    "FFP"  => "Family First Party",
    "FLX"  => "VOTEFLUX.ORG | Upgrade Democracy!",
    "GLT"  => "Glenn Lazarus Team",
    "GRN"  => "Australian Greens",
    "HMP"  => "Help End Marijuana Prohibition (HEMP) Party",
    "IND"  => "Independent",
    "JLN"  => "Jacqui Lambie Network",
    "KAP"  => "Katter's Australian Party",
    "LDP"  => "Liberal Democratic Party",
    "LIB"  => "Liberal Party of Australia",
    "LNP"  => "Liberal Party of Australia",
    "MFP"  => "John Madigan's Manufacturing and Farming Party",
    "NAT"  => "National Party of Australia",
    "NCP"  => "Non-Custodial Parents Party (Equal Parenting)",
    "NXT"  => "Nick Xenophon Team",
    "ODD"  => "Online Direct Democracy - (Empowering the People!)",
    "ONP"  => "Pauline Hanson's One Nation",
    "PIR"  => "Pirate Party Australia",
    "PROG" => "Australian Progressives",
    "PUP"  => "Palmer United Party",
    "REP"  => "Renewable Energy Party",
    "RUA"  => "Rise Up Australia Party",
    "SAL"  => "Socialist Alliance",
    "SCP"  => "Science Party",
    "SEP"  => "Socialist Equality Party",
    "SPP"  => "#Sustainable Australia",
    "TAP"  => "The Arts Party",
    "VEP"  => "Voluntary Euthanasia Party"
  }

  def self.call
    new.call
  end

  def call
    CSV.open("additional.csv", "wb") do |csv|
      csv << [
        'Name', 'Electorate', 'Party', 'webpage', 'twitter', 'facebook',
        'source'
      ]

      new_rows.each do |row|
        csv << [
          row[:name], row[:electoratename], normalised_party(row[:partycode]),
          nil, nil, nil, SOURCE
        ]
      end
    end
  end

  private

  def abc
    @abc ||= CSV.parse File.read("_data/candidates_abc.csv"),
      :headers           => :first_row,
      :header_converters => :symbol
  end

  def existing
    @existing ||= MyCandidates::CandidatesCSV.call
  end

  def matching_row?(abc, known)
    matching_name       = abc[:name] == known[:name] ||
      "Dr #{abc[:name]}" == known[:name]
    matching_electorate = abc[:electoratename] == known[:electorate]
    matching_party      = normalised_party(abc[:partycode]) == known[:party]

    return true if matching_name && matching_electorate && abc[:partycode] == 'IND'
    return true if matching_name && matching_electorate && matching_party

    if !matching_name && matching_electorate && matching_party && abc[:partycode] != 'IND'
      puts "Mismatch: #{abc[:name]} / #{known[:name]} for #{known[:electorate]} / #{known[:party]}"
    end

    false
  end

  def new_rows
    abc.select do |row|
      existing.detect { |known_row| matching_row?(row, known_row) }.nil?
    end
  end

  def normalised_party(code)
    code == 'IND' ? nil : PARTIES[code]
  end
end
