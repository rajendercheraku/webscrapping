require 'rubygems'
require 'HTTParty'
#require 'bundler/setup'
#require 'active_support/all'
require 'nokogiri'
require "byebug"
require 'logger'
require 'csv'
require 'json'


  url = 'https://www.indeed.co.in/fresher-jobs-in-India'
  html_content = HTTParty.get(url)
  response = Nokogiri::HTML(html_content)
  puts response
  total_listings = response.css('div.messageContainer').css('div.resultsTop').css('div[id = "searchCount"]')
  puts total_listings.text
  #pages = (total_listings.(:to_f)/50.to_f).(:ceil).(:text).(:split).(3)

 