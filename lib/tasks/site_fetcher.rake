require 'rake'
require "Nokogiri"
require "open-uri"
def aggregate_listings(uri)
	doc = Nokogiri::HTML(open(uri))
	listings = doc.css('li.site-listing')

	listings.each do |listing|
	  rank = listing.css('div')[0].text.to_i
	  puts listing.css('div.desc-container p a')[0]['href']
	  name = listing.css('div.desc-container p a').text 
	  url = listing.css('div.desc-container p a')[0]['href']

	  Listing.create(rank: rank, url: url, name: name)
	  puts "rankings have been updated with #{name} in position #{rank} with URl: #{url}"
	end
end
desc 'Fetch top 100 sites'
task :fetch_sites => :environment do
	
	Listing.destroy_all

	uri = "http://www.alexa.com/topsites"
	aggregate_listings(uri)

	(1..3).each do |postfix|
		uri = "http://www.alexa.com/topsites/global;#{postfix}"
		aggregate_listings(uri)
	end
end