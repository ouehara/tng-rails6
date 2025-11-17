class ContactController < ApplicationController
  # Signin not required

  # GET /contact/new
  def new
    @contact = Contact.new
  end

  # POST /contact
  # POST /contact.json
  def create
    if (params["contact_us"].present?)
      redirect_to :controller => 'contact', :action => 'new'
      return
    end
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.save
        ContactMailer.information_email.deliver_later
        format.html { redirect_to action: :thankyou, notice: 'Contact was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # GET /contact/thankyou
  def thankyou
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :title, :content, :email,:agreement)
  end

end
