class OrdersController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		@orders = Order.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @orders }
			format.js
		end
	end

	def destroy
		@order = Order.find(params[:id])
		if @order.destroy
			redirect_to action: 'index', status: 303
		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@order = Order.new(order_params)

		if @order.save
			respond_to do |format|
				format.js {render js: "window.location.pathname='#{orders_path}'"}
			end
		else
			respond_to do |format|
				format.json { render json: @order.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def update
		@order = Order.find(params[:id])


		if @order
			if params[:image].present?
				uploaded_file = params[:image]
				image_filename = File.split(uploaded_file.path).last
				upload_image uploaded_file, image_filename
				@order.image = image_filename
			end

			if @order.update_attributes(order_params)
				respond_to do |format|
					format.html { render 'show'}
					format.json { render json: {id: session[:order_id], name: session[:name], can_admin: session[:can_admin]} }
					format.js { render 'updated' }
				end
			else
				render js: 'alert("Cannot modify order")', status: :internal_server_error
			end
		else
			render js: 'alert("Order not found!")'
		end
	end

	def show
		@order = Order.find(params[:id])

		if @order

			respond_to do |format|
				format.json { render json: @order }
				format.html
			end

		else

			respond_to do |format|
				format.json {render nothing: true, status: :no_content }
				format.js { render 'alert("Order not found!")', status: :no_content }
			end

		end

	end

	private

	def sortable_columns
		@sortable_columns = Order.column_names
		exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
		@sortable_columns -= exclusive_columns 
	end

end
