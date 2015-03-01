class AuthorsController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		@authors = Author.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @authors }
			format.js
		end
	end

	def destroy
		@author = Author.find(params[:id])
		if @author.destroy
			redirect_to action: 'index', status: 303
		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@author = Author.new(author_params)

		if @author.save
			respond_to do |format|
				format.html {render 'show'}
				format.js {render js: "window.location.pathname='#{authors_path}'"}
			end
		else
			respond_to do |format|
				format.json { render json: @author.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def update
		@author = Author.find(params[:id])


		if @author
			if params[:image].present?
				uploaded_file = params[:image]
				image_filename = File.split(uploaded_file.path).last
				upload_image uploaded_file, image_filename
				@author.image = image_filename
			end

			if @author.update_attributes(author_params)
				respond_to do |format|
					format.html { render 'show'}
					format.json { render json: {id: session[:author_id], name: session[:name], can_admin: session[:can_admin]} }
					format.js { render 'updated' }
				end
			else
				render js: 'alert("Cannot modify author")', status: :internal_server_error
			end
		else
			render js: 'alert("Author not found!")'
		end
	end

	def show
		@author = Author.find(params[:id])

		if @author

			respond_to do |format|
				format.json { render json: @author }
				format.html
			end

		else

			respond_to do |format|
				format.json {render nothing: true, status: :no_content }
				format.js { render 'alert("Author not found!")', status: :no_content }
			end

		end

	end

	def edit
		@author = Author.find(params[:id])
	end

	def new
		@author = Author.new
		render 'edit'
	end

	private
	def author_params
		params.require(:author).permit(:first_name, :last_name, :preferred_name, :nationality)
	end


	def sortable_columns
		@sortable_columns = Author.column_names
		exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
		@sortable_columns -= exclusive_columns 
	end

	def upload_image(uploaded_file, image_filename)
		File.open(Rails.root.join('app', 'assets', 'images', 'uploads', 'authors', image_filename), 'wb') do |file|
			file.write(uploaded_file.read)
		end
	end

end
