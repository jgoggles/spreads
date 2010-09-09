require 'rubygems'
require 'open-uri'
require 'hpricot'

class Game < ActiveRecord::Base
  attr_accessor :spread
  has_many :picks
  belongs_to :week

  def self.with_spreads(user=nil)
    lines = get_lines
    week = Week.current.first
    games = week.games 
    games.each do |game|
      lines.each do |line|
        if game.away == line['game']['away'] && game.home == line['game']['home']
          game.update_attributes(:spread => line['line'])
        end
      end
    end

    if user
      if user.pick_sets.where("week_id = #{week.id}")[0]
        picks = user.pick_sets.where("week_id = #{week.id}")[0].picks
        picks.each do |p|
          games.each do |g|
            if g.id == p.game_id
              g.update_attributes(:spread => nil)
            end
          end
        end
      end
    end
    return games
  end
  
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
