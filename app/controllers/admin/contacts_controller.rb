class Admin::ContactsController < Admin::ApplicationController
  include AdminOnlyConcern
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_ransack_search_object

  # GET /admin/contacts
  # GET /admin/contacts.js
  # @param [String] order Order
  # @param [String] page Pagination
  def index
    @contacts = @q.result(distinct: true).order('id desc').page(params[:page])

    respond_to do |format|
      format.html { render }
      format.js { render }
    end
  end

  # GET /admin/contacts/1
  # GET /admin/contacts/1.json
  def show
    #puts Contact.states[:unread]
    if @contact.unread?
      @contact.state = Contact.states[:read]
      @contact.save
    end
  end

  # GET /admin/contacts/new
  def new
    @contact = Contact.new
  end

  # GET /admin/contacts/1/edit
  def edit
  end

  # POST /admin/contacts
  # POST /admin/contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to [:admin, @contact], notice: 'contact was successfully created.' }
        # format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        # format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/contacts/1
  # PATCH/PUT /admin/contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to [:admin, @contact], notice: 'contact was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/contacts/1
  # DELETE /admin/contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to admin_contacts_url, notice: 'contact was successfully destroyed.' }
    end
  end

  def answer
    contact = Contact.find(params[:contact])
    contact.state = Contact.states[:answered]
    contact.save
    ContactMailer.contact_answer_email( contact, params[:comment], params[:lang]).deliver_later
    respond_to do |format|
      format.html { redirect_to admin_contacts_url, notice: 'Answer was sent' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :title, :content, :email, :state)
  end

  # Set ransack search object
  def set_ransack_search_object
    @q = Contact.ransack(params[:q])
  end
end
