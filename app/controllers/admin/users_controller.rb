class Admin::UsersController < Admin::ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /admin/users
  # GET /admin/users.json
  def index
    if current_user.administrator?
      @users = User.search(params[:search]).page(params[:page]).order('id desc')
    else
      @users = User.where(id: current_user.id).page(params[:page]).order('id desc')
    end

  end

  # GET /admin/users/1
  # GET /admin/users/1.json
  def show
  end

  # GET /admin/users/new
  def new
    if current_user.administrator?
      @user = User.new
    else
      redirect_to admin_users_url, notice: 'User was successfully destroyed.' 
    end
  end

  # GET /admin/users/1/edit
  def edit
    if !current_user.administrator? && current_user.id != @user.id
      redirect_to admin_users_url, notice: 'User was successfully destroyed.' 
      return
    end
  end

  # POST /admin/users
  # POST /admin/users.json
  def create
    if !current_user.administrator?
      redirect_to admin_users_url, notice: 'User was successfully destroyed.' 
      return
    end
    @user = User.new(admin_user_params)

    # Skip confirmation email when created through admin views
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.html { redirect_to [:admin, @user], notice: 'User was successfully created.' }
        # format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        # format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/users/1
  # PATCH/PUT /admin/users/1.json
  def update
    if current_user.id != @user.id && !current_user.administrator?
      redirect_to admin_users_url, notice: 'User was successfully destroyed.' 
      return
    end
    # Clean password when it was left blank
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    else
      @user.pass_changed=true 
    end
    @user.skip_reconfirmation!
    respond_to do |format|
      
      if @user.update(admin_user_params)
        @user.flush_user_articles_cache
        format.html { redirect_to [:admin, @user], notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /admin/users/1
  # DELETE /admin/users/1.json
  def destroy
    if !current_user.administrator?
      redirect_to admin_users_url, notice: 'User was successfully destroyed.' 
      return
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'User was successfully destroyed.' }
      # format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_user_params
    permitted = User.globalize_attribute_names + [:email, :password, :password_confirmation, :role, :username, :avatar,:description,:facebook,:twitter,:google,:pintrest,:instagram, :has_page]
    params.require(:user).permit(permitted)
  end

end
