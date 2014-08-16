class GalleriesController < ApplicationController
  before_filter :authenticate_user, :only => [:new, :edit, :index]

  def index
    @galleries = Gallery.find(:all, :conditions => [ "user_id = ?", @current_user.id])
  end

  def show
    @gallery = Gallery.find(params[:id])
  end

  def new
    @gallery = Gallery.new
  end

  def create
    @gallery = Gallery.new(params[:gallery])
    if @gallery.save
      flash[:notice] = "Saved"
    else
      flash[:notice] = "Form is invalid"
      flash[:color] = "invalid"
    end
    redirect_to :action => 'index'
  end

  def edit
      @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = "Successfully updated gallery."
      redirect_to @gallery
    else
      render :action => 'edit'
    end
  end

  def destroy
    @gallery = Gallery.find(params[:id])
    @gallery.destroy
    flash[:notice] = "Successfully destroyed gallery."
    redirect_to galleries_url
  end
end
