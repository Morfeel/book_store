class PublishersController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		@publishers = Publisher.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @publishers }
			format.js
		end
	end

	def destroy
		@publisher = Publisher.find(params[:id])
		if @publisher.destroy
			redirect_to action: 'index', status: 303
		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@publisher = Publisher.new(publisher_params)

		if @publisher.save
			respond_to do |format|
				format.html {redirect_to publisher_path(@publisher)}
				format.js {render js: "window.location.pathname='#{orders_path}'"}
			end
		else
			respond_to do |format|
				format.json { render json: @publisher.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def update
		@publisher = Publisher.find(params[:id])


		if @publisher

			if @publisher.update_attributes(publisher_params)
				respond_to do |format|
					format.html { render 'show'}
					format.json { render json: {id: session[:order_id], name: session[:name], can_admin: session[:can_admin]} }
					format.js { render 'updated' }
				end
			else
				render js: 'alert("Cannot modify order")', status: :internal_server_error
			end
		else
			render js: 'alert("Publisher not found!")'
		end
	end

	def show
		@publisher = Publisher.find(params[:id])

		if @publisher

			respond_to do |format|
				format.json { render json: @publisher }
				format.html
			end

		else

			respond_to do |format|
				format.json {render nothing: true, status: :no_content }
				format.js { render 'alert("Publisher not found!")', status: :no_content }
			end

		end

	end

	def new
		@publisher = Publisher.new
		render 'edit'	
	end

	def edit
		@publisher = Publisher.find(params[:id])

	end

	private
	def publisher_params
		params.require(:publisher).permit(:name)
	end


	def sortable_columns
		@sortable_columns = Publisher.column_names
		exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
		@sortable_columns -= exclusive_columns 
	end
	
end
