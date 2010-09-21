class PickSetsController < ApplicationController
  before_filter :authenticate_user!

  # GET /pick_sets
  # GET /pick_sets.xml
  def index
    @current_pick_set = Week.current.first.pick_sets.where("user_id = #{current_user.id}").first
    # @league_pick_sets = User.where("id != #{current_user.id}") 
    @week = Week.current.first
    @title = "Week #{@week.name} picks"

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
    if current_user.has_picks_for_this_week
      redirect_to pick_sets_url, :alert => 'You can\'t create picks for this week anymore. View or add picks below.'
    else
      @pick_set = PickSet.new
      @games = Game.with_spreads
      @week = Week.current.first
      @title = "Week #{@week.name} picks"

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @pick_set }
      end
    end
  end

  # GET /pick_sets/1/edit
  def edit
    @pick_set = PickSet.find(params[:id])
    @games = Game.with_spreads(current_user)
    @week = Week.current.first
    @title = "Week #{@week.name} picks"
  end

  # POST /pick_sets
  # POST /pick_sets.xml
  def create
    @pick_set = PickSet.new(params[:pick_set])
    @pick_set.user_id = current_user.id
    @pick_set.week_id = Week.current.first.id
    @games = Game.with_spreads
    @week = Week.current.first
    @title = "Week #{@week.name} picks"

    respond_to do |format|
      if @pick_set.save
        format.html { redirect_to(pick_sets_url, :notice => 'Pick set was successfully created.') }
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
    @games = Game.with_spreads(current_user)
    @week = Week.current.first
    @title = "Week #{@week.name} picks"

    respond_to do |format|
      if @pick_set.update_attributes(params[:pick_set])
        format.html { redirect_to(pick_sets_url, :notice => 'Pick set was successfully updated.') }
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
  
end
