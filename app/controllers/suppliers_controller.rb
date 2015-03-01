class SuppliersController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		@suppliers = Supplier.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @suppliers }
			format.js
		end
	end

	def destroy
		@supplier = Supplier.find(params[:id])
		if @supplier.destroy
			redirect_to action: 'index', status: 303
		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@supplier = Supplier.new(supplier_params)

		if @supplier.save
			respond_to do |format|
				format.html {redirect_to supplier_path(@supplier)}
				format.js {render js: "window.location.pathname='#{orders_path}'"}
			end
		else
			respond_to do |format|
				format.json { render json: @supplier.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def update
		@supplier = Supplier.find(params[:id])


		if @supplier

			if @supplier.update_attributes(supplier_params)
				respond_to do |format|
					format.html { render 'show'}
					format.json { render json: {id: session[:order_id], name: session[:name], can_admin: session[:can_admin]} }
					format.js { render 'updated' }
				end
			else
				render js: 'alert("Cannot modify order")', status: :internal_server_error
			end
		else
			render js: 'alert("Supplier not found!")'
		end
	end

	def show
		@supplier = Supplier.find(params[:id])

		if @supplier

			respond_to do |format|
				format.json { render json: @supplier }
				format.html
			end

		else

			respond_to do |format|
				format.json {render nothing: true, status: :no_content }
				format.js { render 'alert("Supplier not found!")', status: :no_content }
			end

		end

	end

	def new
		@supplier = Supplier.new
		render 'edit'	
	end

	def edit
		@supplier = Supplier.find(params[:id])

	end

	private
	def supplier_params
		params.require(:supplier).permit(:name, :tel, :email)
	end


	def sortable_columns
		@sortable_columns = Supplier.column_names
		exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
		@sortable_columns -= exclusive_columns 
	end
end
