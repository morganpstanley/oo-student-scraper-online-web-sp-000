require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card").each do |student|
      name =  student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").first.values[0]
      students << {:name=> name, :location=> location, :profile_url=> profile_url}
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    student = {}
    i = 0
    while defined?(doc.css(".social-icon-container").css("a")[i]['href'])

      if doc.css(".social-icon-container").css("a")[i]['href'].include?("twitter")
        twitter = doc.css(".social-icon-container").css("a")[i]['href']
        student[:twitter] = twitter

      elsif doc.css(".social-icon-container").css("a")[i]['href'].include?("linkedin")
        linkedin = doc.css(".social-icon-container").css("a")[i]['href']
        student[:linkedin] = linkedin

      elsif doc.css(".social-icon-container").css("a")[i]['href'].include?("github")
        github = doc.css(".social-icon-container").css("a")[i]['href']
        student[:github] = github

      else
        blog = doc.css(".social-icon-container").css("a")[i]['href']
        student[:blog] = blog
      end
      i += 1
    end

    profile_quote = doc.css(".profile-quote").text.strip
    student[:profile_quote] = profile_quote

    bio = doc.css("p").text.strip
    student[:bio] = bio

    student
  end
end
