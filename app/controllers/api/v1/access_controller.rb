class Api::V1::AccessController < ApplicationController

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
            render json: {id: session[:user_id], name: session[:name], can_admin: session[:can_admin]}
          else
            render json: {password: 'Your email and password are not match'}, status: :unprocessable_entity
          end
        else
          render json: {email: 'The email you just typed in has not been registed'}, status: :unprocessable_entity
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
    render json: {message: 'success'}
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

  private

    def confirm_logged_in
      
    end

end
