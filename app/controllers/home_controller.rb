
class HomeController < ApplicationController
  
  def index
    
  end

  def portfolio
    render :layout => false
  end
  
  def contact
    @contact = Contact.new(params[:contact])
    if request.post?
      if @contact.save
         flash.now[:notice] = 'Your Message Successfully Sent.'
        redirect_to '/'
      else
        render :action => "contact",:layout => false
      end
    else
      render :layout => false
    end
  end



end
