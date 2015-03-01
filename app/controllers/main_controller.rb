class MainController < ApplicationController

  def index
  	@books = Book.all.page(params[:page]).per_page(10)
  end
  
end
