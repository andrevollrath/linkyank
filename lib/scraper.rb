# Company.where('revenue < 2 AND revenue > 0.100').count

# So this isn't too hard. Need to figure out what info I want to pull from the database
# Will have a function that just reads from public for now and writes all names to the DB
# Can make the linkedin user ID unique. 
# 
# Second function will generate company info
# Third function will create emails.
# Also add an auto mode eventually.
# Can add an export column, to pull data, as well as views to see various data.

module Scraper
  module Console
    def iy
      index_yank
    end
    def cy
      company_yank
    end


    def index_yank    
      url = "#{Rails.root}/public/yank-488v00.html"
      html = Nokogiri::HTML(open(url))
      e = html.search("code")[1]

      JSON.parse(e.to_s.match(/(?<=<!--)(.*)(?=-->)/)[0])["searchResults"]
    
      #i.each{|e| k << e['company']['companyId'] if e['company'].key?('companyId')}
    end

    def company_yank
      url = "#{Rails.root}/public/yank-company-0v02.html"
      html = Nokogiri::HTML(open(url))
      str = ""

      html.search("code").each do |e|
        str << e.text
      end
      #str.match(/(?<=companyPageUrl":")(.*?)(?=",)/)[0].match(/(?<=www.)(.*)/)[0]
      str
    end
  end
end
