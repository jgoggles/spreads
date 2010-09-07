class PickSetsController < ApplicationController
  # GET /pick_sets
  # GET /pick_sets.xml
  def index
    @pick_sets = PickSet.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pick_sets }
    end
  end

  # GET /pick_sets/1
  # GET /pick_sets/1.xml
  def show
    @pick_set = PickSet.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pick_set }
    end
  end

  # GET /pick_sets/new
  # GET /pick_sets/new.xml
  def new
    @pick_set = PickSet.new
    @games = games_with_spreads 
    @pick_set.picks.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pick_set }
    end
  end

  # GET /pick_sets/1/edit
  def edit
    @pick_set = PickSet.find(params[:id])
  end

  # POST /pick_sets
  # POST /pick_sets.xml
  def create
    @pick_set = PickSet.new(params[:pick_set])
    @pick_set.user_id = current_user.id

    respond_to do |format|
      if @pick_set.save
        format.html { redirect_to(@pick_set, :notice => 'Pick set was successfully created.') }
        format.xml  { render :xml => @pick_set, :status => :created, :location => @pick_set }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pick_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pick_sets/1
  # PUT /pick_sets/1.xml
  def update
    @pick_set = PickSet.find(params[:id])

    respond_to do |format|
      if @pick_set.update_attributes(params[:pick_set])
        format.html { redirect_to(@pick_set, :notice => 'Pick set was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pick_set.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pick_sets/1
  # DELETE /pick_sets/1.xml
  def destroy
    @pick_set = PickSet.find(params[:id])
    @pick_set.destroy

    respond_to do |format|
      format.html { redirect_to(pick_sets_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def games_with_spreads
    lines = Pick.get_lines
    games = Game.find_all_by_week('p')
    games.each do |game|
      lines.each do |line|
        if game.away == line['game']['away'] && game.home == line['game']['home']
          game.update_attributes(:spread => line['line'])
        end
      end
    end
    return games
  end
end
