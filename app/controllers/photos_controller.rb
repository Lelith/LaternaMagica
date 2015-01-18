class PhotosController < ApplicationController

  def show
    my_photo = Photo.find(params[:id])
    photo_gallery = Gallery.find(my_photo.gallery_id)
    if is_accessable(photo_gallery)
      @photo = my_photo
    else
      flash[:notice] ="this gallery is private"
    end
  end

  def new
    @photo = Photo.new(:gallery_id => params[:gallery_id])
  end

  def create
    @photo = Photo.new(params[:photo])

    if @photo.save
      flash[:notice] = "Photo saved"
      redirect_to "/galleries/#{@photo.gallery_id}"
    else
      flash[:color] = "invalid"
      render :action => :new
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
    redirect_to "/galleries/#{@photo.gallery_id}"
  end
end
