class ShowsController < ApplicationController

  before_filter :is_boxoffice_manager_filter
  before_filter :has_at_least_one, :except => [:new, :create]

  include VouchertypesHelper    # for season formatting
  
  def index
    @superadmin = current_user.is_admin
    @season = (params[:season].to_i > 1900 ? params[:season].to_i : Time.this_season)
    @earliest,@latest = Show.seasons_range
    @season = @latest unless @season.between?(@earliest,@latest)
    @shows = Show.all_for_season(@season)
    @page_title = "#{humanize_season @season} Shows"
  end

  def new
    @show = Show.new(:listing_date => Date.today,
      :sold_out_dropdown_message => '(Sold Out)',
      :sold_out_customer_info => 'No tickets on sale for this performance')
    @page_title = "Add new show"
  end

  def create
    @show = Show.new(params[:show])
    if @show.save
      redirect_to edit_show_path(@show),
      :notice =>  'Show was successfully created. Click "Add A Performance" below to start adding show dates.'
    else
      flash[:alert] = ["There were errors creating the show: ", @show.errors.as_html]
      render :action => 'new'
    end
  end

  def edit
    @show = Show.find(params[:id])
    @showdates = @show.showdates.sort_by { |s| s.thedate }
    @is_boxoffice_manager = is_boxoffice_manager
    if params[:display].blank?
      @maybe_hide = "display: none;"
    end
    @page_title = %Q{Details: "#{@show.name}"}
  end

  def update
    @show = Show.find(params[:id])
    @showdates = @show.showdates
    if @show.update_attributes(params[:show])
      redirect_to edit_show_path(@show), :notice => 'Show details successfully updated.'
    else
      flash[:alert] = ["Show details could not be updated: ", @show.errors.as_html]
      render :action => 'edit', :id => @show
    end
  end

  def destroy
    Show.find(params[:id]).destroy
    redirect_to shows_path
  end
end
