class UsersController < ApplicationController

  before_action :sortable_columns

  def index
    @users = User.all.page(params[:page]).per_page(10)
    
    respond_to do |format|
      format.html
      format.json { render json: @users }
      format.js
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to action: 'index', status: 303
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(register_params)
    g = Group.find_by_name('cust')
    if g.users << @user
      session[:user_id] = @user.id
      session[:name] = @user.preferred_name.blank? ? (@user.first_name.blank? ? 'There' : @user.first_name) : @user.preferred_name
      session[:can_admin] = @user.can_admin?
      respond_to do |format|
              format.json { render json: {id: session[:user_id], name: session[:name], can_admin: session[:can_admin]} }
              format.js { render 'registerred' }
      end
    else
      respond_to do |format|
              format.json { render json: @user.errors, status: :unprocessable_entity }
              format.js { render 'register_error', status: :unprocessable_entity }
            end
          end

  end

  def update
    @user = User.find(params[:id])
    if @user
      
      if @user.update_attributes(update_params)
        session[:name] = @user.preferred_name.blank? ? (@user.first_name.blank? ? 'There' : @user.first_name) : @user.preferred_name
        session[:can_admin] = @user.can_admin?
        respond_to do |format|
          format.html { render 'show'}
          format.json { render json: {id: session[:user_id], name: session[:name], can_admin: session[:can_admin]} }
          format.js { render 'updated' }
        end
      else
        render js: 'alert("Cannot modify user")'
      end
    else
      render js: 'alert("User not found!")'
    end
  end

  def show
    @user = User.find(params[:id])

    if @user

      respond_to do |format|
            format.json { render json: @user }
            format.html
      end

    else

      respond_to do |format|
            format.json {render nothing: true, status: :no_content }
            format.js { render 'alert("User not found!")', status: :no_content }
      end

    end
    
  end
  def edit
    @user = User.find(params[:id])
    
  end

  private
    def register_params
      params.require(:user).permit(:email, :password, :password_confirmation, :accept)
    end

    def update_params
      params.require(:user).permit(:first_name, :last_name, :preferred_name, :street, :suburb, :city, :tel, :mobile, :postal_code)
    end

    def update_password_params
      params.require(:user).permit(:password, :password_confirmation,)
    end

    def sortable_columns
      @sortable_columns = User.column_names
      exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
      @sortable_columns -= exclusive_columns 
    end
end
