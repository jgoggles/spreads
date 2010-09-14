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
        if line['game']['away'] == game.away && line['game']['home'] == game.home
          game.update_attributes(:spread => line['game']['line'])
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
    @url = "http://sports.bodog.com/sports-betting/nfl-football.jsp"
    @response = ''

    begin
      open(@url) { |f|
        @response = f.read
      }
        
      doc = Hpricot(@response)
      lines = []
      
      # rows = (doc/"/html/body/div[2]/div[2]/div/div[2]/div[2]/div/div/div/table/tr.stathead/td")
      # 
      # rows.each do |d|
      #     lines.push(Hash.new)
      #     lines[rows.index(d)]['game'] = {}
      #     d.inner_html.match(/(.*)(\sat\s)(.*)(,.*)/)
      #     lines[rows.index(d)]['game']['home'] = $3
      #     lines[rows.index(d)]['game']['away'] = $1
      #     lines[rows.index(d)]['game']['time'] = $4.gsub(", ", "")
      # end
      # 
      # spreads = (doc/"/html/body/div[2]/div[2]/div/div[2]/div[2]/div/div/div/table/tr.oddrow")
      # 
      # spreads.each do |d|
      #   if d.at("td.sortcell").inner_html.gsub!(/.*>/, "") != "n/a" && d.at("td[2]").inner_html.gsub!(/<.*/, "") != "n/a"
      #     lines[spreads.index(d)]['line'] = d.at("td[2]").inner_html.gsub!(/.*>/, "")
      #   else
      #     lines[spreads.index(d)]['line'] = "n/a"
      #   end
      # end
      
      rows = (doc/"/html/body/div/div/div[4]/form/div/div[2]/div[7]/div/div.event")

      rows.each do |d|
        away = d.at("table/tr/td[3]/div.competitor-name/a").inner_html
        home = d.at("table/tr[2]/td[3]/div.competitor-name/a").inner_html
        line = d.at("table/tr[2]/td[4]/div.line-normal")
        if line.at("a").nil?
          line = "n/a"
        else
          line = line.at("a").inner_html
        end
        lines.push(Hash.new)
        lines[rows.index(d)]['game'] = {}
        lines[rows.index(d)]['game']['home'] = home.gsub(/\s\w*$/, '')
        lines[rows.index(d)]['game']['away'] = away.gsub(/\s\w*$/, '')
        lines[rows.index(d)]['game']['line'] = line.gsub(/\s\(.*/, '').to_f
       end
      
      return lines

    rescue Exception => e
      print e, "\n"
    end
  end

  def self.get_scores(week)
    @url = "http://www.nfl.com/scores/2010/REG#{week.name}"
#    @url = "http://www.nfl.com/scores/2010/PRE4"
    @response = ''

    begin
      open(@url) { |f|
        @response = f.read
      }

      @response.gsub!(/sb-wrapper-\d*/, "sb-wrapper")

      doc = Hpricot(@response)
      scores = []
      containers = (doc/"/html/body/div[4]/div/div/div/div[2]/div/div[5]/div#sb-wrapper") 

      containers.each do |container|
        scores.push(Hash.new)
        scores[containers.index(container)]['game'] = {}
        g = scores[containers.index(container)]['game']
        g['away_team']  = container.at("div/div/div/div[3]/ul.away-team/li[2]/div/a").inner_html
        g['home_team']  = container.at("div/div/div/div[3]/ul.home-team/li[2]/div/a").inner_html
        g['away_score'] = container.at("div/div/div/div.game-info-section/div.away-score/div.the-score").inner_html
        g['home_score'] = container.at("div/div/div/div.game-info-section/div.home-score/div.the-score").inner_html
      end

      games = week.games 
      games.each do |game|
        scores.each do |score|
          if game.away =~ /#{score['game']['away_team']}/ && game.home =~ /#{score['game']['home_team']}/
            game.update_attributes(:away_score => score['game']['away_score'], :home_score => score['game']['home_score'])
          end
        end
      end

    rescue Exception => e
      print e, "\n"
    end

  end

  def has_scores
   !self.home_score.nil? && !self.away_score.nil? 
  end
end
