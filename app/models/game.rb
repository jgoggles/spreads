require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'nokogiri'

class Game < ActiveRecord::Base
  attr_accessor :spread, :over_under
  has_many :picks
  belongs_to :week

  def self.with_spreads(user=nil, test=false)
    if test
      lines = get_lines
    else
      lines = get_lines_2
    end
    week = Week.current.first
    games = week.games
    begin
      games.each do |game|
        lines.each do |line|
          if game.away =~ /#{line['game']['away']}/ && game.home =~ /#{line['game']['home']}/
            game.update_attributes(:spread => line['game']['line'], :over_under => line['game']['over_under'])
          end
        end
      end

      if user
        if user.pick_sets.where("week_id = #{week.id}")[0]
          picks = user.pick_sets.where("week_id = #{week.id}")[0].picks
          picks.each do |p|
            games.each do |g|
              if g.id == p.game_id
                g.update_attributes(:spread => "n/a")
              end
            end
          end
        end
      end
      return games
    rescue
      return false
    end
  end
  
  def self.get_lines 
    url = 'http://sports.bodog.com/sports-betting/nfl-football.jsp'

    begin
      doc = Nokogiri::HTML(open(url))

      rows = doc.css('div.event')
      lines = []

      if rows
        rows.each do |a|
          if a.css('div.competitor-name a').first.nil?
            away = a.css('div.competitor-name span.disabled').first.content
            home = a.css('div.competitor-name span.disabled')[1].content
          else
            away = a.css('div.competitor-name a').first.content
            home = a.css('div.competitor-name a')[1].content
          end

          if a.css('div.line-normal a')[1].nil? && a.css('div.line-sharp a')[1].nil?
              line = "n/a"
          elsif !a.css('div.line-normal a')[1].nil? && a.css('div.line-sharp a')[1].nil?
              line = a.css('div.line-normal a')[1].content
          elsif a.css('div.line-normal a')[1].nil? && !a.css('div.line-sharp a')[1].nil?
              line = a.css('div.line-sharp a')[1].content
          end

          lines.push(Hash.new)
          lines[rows.index(a)]['game'] = {}
          lines[rows.index(a)]['game']['home'] = home.gsub(/\s\w*$/, '')
          lines[rows.index(a)]['game']['away'] = away.gsub(/\s\w*$/, '')
          lines[rows.index(a)]['game']['line'] = line.gsub(/\s\(.*/, '').gsub("½", ".5")
        end
      end

      return lines
    rescue Exception => e
      print e, "\n"
    end
  end
  
  def self.get_lines_2
    url = 'http://www.sportsinteraction.com/football/nfl-betting-lines/'

    begin
      doc = Nokogiri::HTML(open(url))

      rows = doc.css('div.game')
      lines = []

      if rows
        rows.each do |a|
          if !a.at_css('div ul[2] li[2] span span.handicap').nil?
            matchup = a.at_css('span.title a').content.match(/(.*)\sat\s(.*)/)
            away = $1.strip!
            home = $2.strip!

            away.gsub!(/\sJets|\sGiants/, "")
            home.gsub!(/\sJets|\sGiants/, "")
        
            line = a.at_css('div ul[2] li[2] span span.handicap').content
            over_under = a.at_css('div ul.twoWay[3] li[2] span span.handicap').content

            lines.push(Hash.new)
            lines[rows.index(a)]['game'] = {}
            lines[rows.index(a)]['game']['home'] = home
            lines[rows.index(a)]['game']['away'] = away
            lines[rows.index(a)]['game']['over_under'] = over_under.strip!.gsub("+", "")
            if line.strip.size == 2 && a.at_css('div ul[2] li[2] span span.price').content.strip.size == 2
              lines[rows.index(a)]['game']['line'] = "n/a"
            elsif a.at_css('div ul[2] li[2] span span.price').content == "Closed"
              lines[rows.index(a)]['game']['line'] = "n/a"
            elsif line.strip.size == 2 && a.at_css('div ul[2] li[2] span span.price').content != "Closed" 
              lines[rows.index(a)]['game']['line'] = "0"
            else
              lines[rows.index(a)]['game']['line'] = line.strip!
            end
          else
            lines.push(Hash.new)
            lines[rows.index(a)]['game'] = {}
            lines[rows.index(a)]['game']['home'] = "n/a"
            lines[rows.index(a)]['game']['away'] = "n/a"
            lines[rows.index(a)]['game']['line'] = "n/a"
          end
        end
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

  def self.avg_totals
    score_total = 0
    game_total = 0
    all.each do |g|
      if g.home_score && g.away_score
        game_total += 1
        score_total += g.home_score
        score_total += g.away_score
      end
    end
    puts score_total.to_f/game_total.to_f
  end
end
