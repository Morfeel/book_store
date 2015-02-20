class AccessController < ApplicationController

  before_action :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def attempt_login

    unless session[:user_id]

      if params[:email].present? && params[:password].present?
        found_user = User.where(:email => params[:email]).first

        if found_user
          authorized_user = found_user.authenticate(params[:password])
          if authorized_user
            session[:user_id] = authorized_user.id
            session[:name] = authorized_user.preferred_name.blank? ? (authorized_user.first_name.blank? ? 'There' : authorized_user.first_name) : authorized_user.preferred_name
            session[:can_admin] = authorized_user.can_admin?
            
            respond_to do |format|
              format.json { render json: {id: session[:user_id], name: session[:name], can_admin: session[:can_admin]} }
              format.js { render 'loggedin' }
            end
          else
            @errors = {password: 'Your email and password are not match'}
            respond_to do |format|
              format.json { render @errors, status: :unprocessable_entity}
              format.js { render 'login_error', status: :unprocessable_entity }
            end
          end
        else
          @errors = {email: 'The email you just typed in has not been registed'}
          respond_to do |format|
            format.json { render @errors, status: :unprocessable_entity}
            format.js { render 'login_error', status: :unprocessable_entity }
          end
        end
      else
        render nothing: true, status: :unprocessable_entity
      end
    else
      render json: {error: 'You have already logged in'}
    end
  end

  def logout
    session[:user_id] = nil
    session[:name] = nil
    session[:can_admin] = false
    respond_to do |format|
      format.html
      format.js { render 'loggedout' }
    end
  end

  def check_email

    if params[:email].present?
      found_user = User.where(:email => params[:email]).first
      if found_user
        render nothing: true, status: :ok
      else
        render nothing: true, status: :unprocessable_entity
      end
    else
      render nothing: true, status: :unprocessable_entity
    end
    
  end

  def register
    user = User.new(user_params)
    g = Group.find_by_name('cust')
    if g.users << user
      session[:user_id] = user.id
      session[:name] = user.preferred_name.blank? ? user.first_name : user.preferred_name
      session[:can_admin] = user.can_admin?
      render json: {id: session[:user_id], name: session[:name], can_admin: session[:can_admin]}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if session[:user_id]
      user = User.find(session[:user_id])
      if user.update_attributes(user_params)
        session[:name] = user.preferred_name.blank? ? user.first_name : user.preferred_name
        session[:can_admin] = user.can_admin?
        render json: {name: session[:name], can_admin: session[:can_admin]}
      else
        render json: user.errors, status: :unprocessable_entitys
      end
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  private

  def confirm_logged_in

  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation, :preferred_name, :street, :suburb, :city, :tel, :mobile, :postal_code, :accept)
  end

end
