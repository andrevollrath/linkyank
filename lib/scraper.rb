# Company.where('revenue < 2 AND revenue > 0.100').count

# So this isn't too hard. Need to figure out what info I want to pull from the database
# Will have a function that just reads from public for now and writes all names to the DB
# Can make the linkedin user ID unique. 
# 
# Second function will generate company info
# Third function will create emails.
# Also add an auto mode eventually.
# Can add an export column, to pull data, as well as views to see various data.
# 
# So will need to test cy pull.
# 
# NEXT STEPS
# 
# Start w/enough pull to generate 1000 emails?
# Will probably be a couple cities worth of data.
# Need to figure out statistics of what I can pull.
# 
# x. Create basic db for info
# B. Pull company page from linkedin
# C. Hookup email API
# D. Generate email permutations
# E. Record correct email or mark for discard
# F. Design batch of emails
# G. Setup Gmail 
# H. Setup DNS subdomain
# I. Hookup woodpecker.io
# J. See reponse rate
# K. Decide whether it is a feasible route.

  # RANK
  # nil = just scraped
  # 0 = company added
  # 1 = email found
  # 2
  # 3
  # 4
  # 5

module Scraper
  module Console

    def hello
      puts "hello"
    end

    def refresh
      load "#{Rails.root}/lib/scraper.rb"
      puts "Reloading =>..." 
    end

    def member_yank(url = nil)      
      @count = 0
      @comp = 0
      files = Dir.glob("#{Rails.root}/public/0c/**/*")
      files.each do |f|
        puts "File --> #{f}"
        k = member_record(f)
        #File.rename(f, f.sub('/public/a', '/public/b')) if k
      end
      puts "Total count: #{@count} :: Attempted Writes #{@comp}"
    end

    def member_record(url = nil)
       unless url
        url = "#{Rails.root}/public/yank-488v00.html"
      end

      html = Nokogiri::HTML(open(url))
      e = html.search("code")[1]

      a = JSON.parse(e.to_s.match(/(?<=<!--)(.*)(?=-->)/)[0])["searchResults"]
    
      a.each do |i|
        @count += 1
        if i['company'].key?('companyId')
          @comp += 1
          m = Member.new
          m.name = i['member']['formattedName']
          m.nid = i['member']['memberId']
          m.title = cleanse(i['member']['title'])
          m.location = i['member']['location']
          m.company = i['company']['companyName']
          m.cid = i['company']['companyId']
          m.save
        end
      end    
    end 
  
    def company_yank
      files = Dir.glob("#{Rails.root}/public/a/**/*")
      files.each do |f|
        puts "File --> #{f}"
        k = company_record(f)
        File.rename(f, f.sub('/public/a', '/public/b')) if k
      end
    end

    private

      def cleanse(s)
        ActionController::Base.helpers.strip_tags(s).titleize
      end


      def company_record(url = "#{Rails.root}/public/yank-company-Xv00.html")
        html = Nokogiri::HTML(open(url))
        i = block_index(html.search("code"))        

        if i
          k = block_to_json(html.search("code")[i])
          
          i = inner_item(k,'$id').match(/(?<=y:)(.*)(?=,)/)[0]           
          l = Member.where(cid: i)
           
          if l.count > 0
            l.each{|p| update_company(p,k)}
            return true
          end
        end
        return false
      end

      def update_company(m,k)
        m.cgeographic = inner_item(k,'geographicArea')
        m.ccity = inner_item(k,'city')
        m.cpostal = inner_item(k,'postalCode')
        m.curl = inner_item(k,'companyPageUrl')
        m.cdescription = inner_item(k,'description')
        s = inner_item(k,'specialities')
        m.cspecialty = s.join(', ') if s
        m.rank = 0
        m.save
      end

      def block_index(h)
        h.each_with_index do |b, i|
          x = valid_block(b)
          puts "-- block_index >> #{i}" if x
          return i if x
        end
        return nil
      end

      def valid_block(b)
        j = block_to_json(b)
        
        if j && j.kind_of?(Array)
          j.each {|e| (return true if e['companyPageUrl'])}
          j.each {|e| (return true if e['description'])}
        end
        return false        
      end

      def block_to_json(b)
        JSON.parse(b.text)['included'] rescue false
      end      

      def inner_item(k,s)
        t = nil
        k.each_with_index do |a,i|
          t = i if k[i][s]
          break if t
        end
        t ? k[t][s] : nil
      end

  end
end
