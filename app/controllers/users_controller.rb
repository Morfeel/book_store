class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def destory
    @user = User.find_by_id(params[:id])
    if @user.destroy
      flash[:notice] = '<script>alert("success")</script>'
      redirect_to(:action =>'index')
    else
      flash[:notice] = '<script>alert("error")</script>'
      redirect_to(:action => 'new')
    end
  end

  def create
    @user = User.new(user_params)
    g = Group.find_by_name('cust')
    if g.users << @user
      session[:user_id] = @user.id
      session[:first_name] = @user.preferred_name.blank? ? @user.first_name : @user.preferred_name
      session[:can_admin] = @user.can_admin?
      redirect_to(controller: 'main', action: 'index')
    else
      puts @user.errors.full_messages
      redirect_to(:action => 'new')
    end

  end

  def update
    @user = User.find_by_id(params[:id])
    @user.update_attributes(user_params)
    redirect_to(:action=> 'index')
  end

  private
    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :preferred_name, :street, :suburb, :city, :tel, :mobile, :postal_code, :accept)
    end
end
