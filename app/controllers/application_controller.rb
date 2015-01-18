class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
    def authenticate_user
      if session[:user_id]
        # set global current user object
        @current_user = User.find session[:user_id]
        return true
      else
        redirect_to(:controller => 'sessions', :action =>'login')
        return false
      end
    end

    def save_login_state
      if session[:user_id]
         redirect_to(:controller => 'sessions', :action => 'home')
         return false
      else
        return true
      end
    end

    def is_accessable (gallery_id)
      my_gallery = Gallery.find(gallery_id)
      if my_gallery.is_private?
        if session[:user_id] != my_gallery.user_id
          return false
        end
      end
      return true
    end
end
