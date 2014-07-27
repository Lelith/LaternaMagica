class PhotosController < ApplicationController

  def show
    @photo = Photo.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(params[:Photo])

    if @photo.save
      flash[:notice] = "Photo saved"
      redirect to @Photo
    else
      flash[:color] = "invalid"
      render "photos/index"
    end
  end

  def edit
      @photo = Photo.find(params[:id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:Photo])
      flash[:notice] = "Successfully updated Photo."
      redirect_to @photo
    else
      render :action => 'edit'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    flash[:notice] = "Successfully destroyed Photo."
    render 'photos/index'
  end
end
