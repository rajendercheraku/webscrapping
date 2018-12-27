require 'rubygems'
require 'HTTParty'
#require 'bundler/setup'
require 'active_support/all'
require 'active_support/core_ext/object/blank'
require 'nokogiri'
require "byebug"
require 'logger'
require 'csv'
require 'json'
     
     
def write_file(result, file_name)
  p"-------------------------------------------------------"
  p result
  CSV.open(file_name, "a+") do |csv|
    p"_______________________________________________________"
    p result.values
    csv << result.values
  end
  p"-------------------------------------------------------"
end

def create_csv(file_name)
  keys = ['job_title', 'url', 'company_name', 'reviews', 'location', 'job_description', 'salary','job_posted_date']

  CSV.open(file_name, "a+") do |csv|
    csv << keys
  end
end
     create_csv("indeed_fresher.csv")

  file_name = "indeed_freshers1"
   url = 'https://www.indeed.co.in/jobs?q=fresher&l=India'
   html_content = HTTParty.get(url)
   response = Nokogiri::HTML(html_content)
   total_listings = response.css('div#searchCount').text.split[3]   
   total_listings = total_listings.scan(/[.0-9]/).join().to_f
   puts total_listings.to_f
   pages = ((total_listings.to_f)/10.to_f).ceil
   p "total pages ---> #{pages}"
   (0..(pages-1)).each do |page_no|
     if page_no != 0
       url = "https://www.indeed.co.in/jobs?q=fresher&l=India&start=#{page_no*10}"
       html_content = HTTParty.get(url)
       response = Nokogiri::HTML(html_content)
    end
     puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
     p url
     p "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
       #sleep(5)
      # byebug
      n=0
      response.css('.jobsearch-SerpJobCard.row.result[data-tn-component="organicJob"]').each do |doc|
      result = {
              job_title: doc.try(:css, 'a').first.try(:text).try(:strip).try(:gsub, ';', ', ').try(:gsub, "\t", ''),
              url: "https://www.indeed.co.in/"+doc.try(:css, '.jobtitle').try(:css, 'a').attr('href').try(:value),
              company_name: doc.try(:css,'span.company').try(:text).try(:strip),                            
              reviews: doc.try(:css,'span.ratings').try(:text),
              location: doc.try(:css,'div.location').try(:text).try(:strip),
              job_description: doc.try(:css,'span.summary').try(:text).try(:strip).try(:gsub, ';', ', ').try(:gsub, "\t", ''),
              salary: doc.try(:css,'div.salarySnippet').try(:text).to_s.try(:strip).try(:gsub, ';', ', ').try(:gsub, "\t", ''),
              job_posted_date: ((doc.try(:css, '.result-link-bar .date').try(:text).try(:strip).try(:scan, /\d+[+]? day/).present?) ? (Time.now.utc.to_date-doc.try(:css, '.result-link-bar .date').try(:text).try(:strip).try(:to_i)) : Time.now.utc.to_date)
             }
             
             

      write_file(result, "indeed_fresher.csv")

    end
  end
