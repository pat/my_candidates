# My Candidates

The goal (as yet unrealised) is this for to be a simple static site that lists all known candidates for the upcoming Australian federal election in July 2016.

## Progress Report

### Done:

* Scraper that sources electorates and the postcodes within them.
* Scraper that sources a list of federal political parties.

### In progress:

* Construct a Google spreadsheet that will be the source of candidates, which can then be turned into popolo data (much like https://github.com/openaustralia/australian_local_councillors_popolo).

### To do:

* Add a Google form to help source candidate data (name, party, electorate, social media links, perhaps a photo).
* Write code to generate pages for each postcode and electorate. If a postcode only has one electorate, redirect to that electorate. If it has more than one, offer the viewer a choice.
* Add meaningful layouts and design.
* On electorate pages, include a link to the Google form to allow people to suggest missing candidates.
* Get some decent candidate data together so the site isn't empty.

## Working on the site:

You'll need Ruby installed, and the bundler gem. Once that is the case:

```
bundle install
```

To run a webserver that hosts the site locally:

```
bundle exec jekyll serve
```

To run the scrapers (note that a recent version of Firefox must be installed, because one of the scrapers uses Selenium due to the annoying requirement of Javascript. Thanks AEC!)

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
