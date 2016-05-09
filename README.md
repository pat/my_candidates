# My Candidates

The goal (somewhat realised) is this for to be a simple static site that lists all known candidates for the upcoming Australian federal election on July 2nd, 2016.

## Progress Report

### Done:

* Scraper that sources electorates and the postcodes within them.
* Scraper that sources a list of federal political parties.
* [A Google spreadsheet](https://docs.google.com/spreadsheets/d/1PaS7lYTs5pAccFIHImzfStKVFdetjGHuHz54DoOdBP4/edit?usp=sharing) that will be the source of candidates.
* [A Google form](https://docs.google.com/forms/d/1mpS6fpwPAQGciaydUn-l_YyCEosYic3PHbdJf6Cz8gc/viewform) to help source candidate data (name, party, electorate, social media links).
* Popolo data sourced from the Google spreadsheet.
* Write code to generate pages for each postcode and electorate. If a postcode only has one electorate, redirect to that electorate. If it has more than one, offer the viewer a choice.
* On electorate pages, include a link to the Google form to allow people to suggest missing candidates.
* Get some decent candidate data together so the site isn't empty.

### In progress:

* Add meaningful layouts and design.

## Working on the site:

You'll need Ruby installed, and the bundler gem. Once that is the case:

```
bundle install
```

To run a webserver that hosts the site locally:

```
bundle exec jekyll serve
```

## Scrapers and Data

Unless there are data changes, you won't need to run any of these tasks - all data and template files are committed to the repository.

### Candidate Information

To regenerate the popolo data from the Google spreadsheet, use the `generate:popolo` rake task:

```
bundle exec rake generate;popolo
```

To rebuild the electorate and postcode pages from the latest popolo data, use the `generate:pages` rake task:

```
bundle exec rake generate:pages
```

And to run them both together (which will be needed every time the Google spreadsheet has updated information), there's a single `rebuild` rake task:

```
bundle exec rake rebuild
```

### Postcodes, Electorates, Parties

Postcode, electorate and party information has been scraped from the AEC website in `_data/electorates.json` and `_data/parties.json`. You shouldn't need to recreate these files from scratch (there's nothing volatile about this data), but on the off chance it is needed, run the following rake tasks:

```
bundle exec rake scrapers:electorates
bundle exec rake scrapers:parties
```

## Contributing

Firstly, please note the Code of Conduct for all contributions to this project. If you accept that, then the steps for contributing are probably something along the lines of:

1. Fork it ( https://github.com/pat/my_candidates/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Licence

Copyright (c) 2016, My Candidates is developed and maintained by Pat Allan, and is released under the open MIT Licence.
