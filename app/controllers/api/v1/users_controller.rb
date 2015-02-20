class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
  end

  def destory
    @user = User.find(params[:id])
    if @user.destroy
      render nothing: true, status: :no_content
    else
      render nothing: true, status: :unprocessable_entity
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
