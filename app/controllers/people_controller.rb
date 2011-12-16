class PeopleController  < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :all, :except=>[:destroy]
  
  def edit
    @people = Person.find(:all, :order => "full_name")
  end
  def update
    @person = Person.find_by_full_name( params[:person][:full_name] )
    @person.attributes = params[:person]
    if @person.save
      flash[:notice] = "Luminary blurb updated"
    else
      flash[:notice] = "There was an error updating that blurb. Please try again."        
    end
    
    redirect_to :back
    
    
  end  

end
