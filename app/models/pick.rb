require 'rubygems'
require 'open-uri'
require 'hpricot'

class Pick < ActiveRecord::Base
  belongs_to :user

  def self.get_lines 
    @url = "http://espn.go.com/nfl/lines"
    @response = ''

    begin
      open(@url) { |f|
        @response = f.read
      }
        
      doc = Hpricot(@response)
      lines = []
      
      rows = (doc/"/html/body/div[2]/div[2]/div/div[2]/div[2]/div/div/div/table/tr.stathead/td")
      
      rows.each do |d|
          lines.push(Hash.new)
          lines[rows.index(d)]['game'] = {}
          d.inner_html.match(/(.*)(\sat\s)(.*)(,.*)/)
          lines[rows.index(d)]['game']['home'] = $3
          lines[rows.index(d)]['game']['away'] = $1
          lines[rows.index(d)]['game']['time'] = $4.gsub(", ", "")
      end
      
      spreads = (doc/"/html/body/div[2]/div[2]/div/div[2]/div[2]/div/div/div/table/tr.oddrow/td[2]")
      
      spreads.each do |d|
          lines[spreads.index(d)]['line'] = d.inner_html.gsub!(/.*>/, "")
      end
      
      return lines

    rescue Exception => e
      print e, "\n"
    end
  end
end
