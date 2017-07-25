class WelcomeController < ApplicationController
	def index
		require 'open-uri'
		require 'net/http'
		require 'json'

		timemap_base_uri = URI('http://web.archive.org/web/timemap/json/http://www.coinbase.com/about')
		response = Net::HTTP.get(timemap_base_uri)

		timemap_json = JSON.parse(response)

		@coinbase_stats = []

		timemap_json.each do |timemap|
			doc = Nokogiri::HTML(open("http://web.archive.org/web/" + timemap[1] + "/http://www.coinbase.com/about"))

			puts "*" * 50
			puts timemap[1]
			puts doc.css("#stats h4:nth-child(2)").text
			puts doc.css("#stats h4:nth-child(3)").text
			puts doc.css("#stats h4:nth-child(4)").text
			puts doc.css("#stats h4:nth-child(5)").text
			puts "*" * 50

			@coinbase_stats << {
				timemap: timemap[1],
				users: doc.css("#stats h4:nth-child(2)").text,
				wallets: doc.css("#stats h4:nth-child(3)").text,
				merchants: doc.css("#stats h4:nth-child(4)").text,
				apps: doc.css("#stats h4:nth-child(5)").text
			}
		end

		render 'index'
	end
end
