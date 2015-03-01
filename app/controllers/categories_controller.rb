class CategoriesController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		params.delete(:id)
		@categories = Category.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @categories }
			format.js {render 'destroy'}
		end
	end

	def destroy
		@category = Category.find(params[:id])

		if @category.destroy
			params.delete(:id)
			@categories = Category.all.page(params[:page]).per_page(10)
			respond_to do |format|
				format.html { redirect_to categories_path }
				format.js
			end

		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@category = Category.new(category_params)

		if params[:image].present?
			uploaded_file = params[:image]
			image_filename = File.split(uploaded_file.path).last
			upload_image uploaded_file, image_filename
			@category.image = image_filename
		end

		if @category.save
			respond_to do |format|
				format.html { redirect_to categories_path }
				format.json { render json: {id: session[:category_id], name: session[:name], can_admin: session[:can_admin]} }
				format.js { render 'updated' }
			end
		else
			respond_to do |format|
				format.json { render json: @category.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def new
		@category = Category.new
		render 'edit'
	end

def update
	@category = Category.find(params[:id])


	if @category
		if params[:image].present?
			uploaded_file = params[:image]
			image_filename = File.split(uploaded_file.path).last
			upload_image uploaded_file, image_filename
			@category.image = image_filename
		end

		if @category.update_attributes(category_params)
			respond_to do |format|
				format.html { render 'show'}
				format.json { render json: {id: session[:category_id], name: session[:name], can_admin: session[:can_admin]} }
				format.js { render 'updated' }
			end
		else
			render js: 'alert("Cannot modify category")', status: :internal_server_error
		end
	else
		render js: 'alert("Category not found!")'
	end
end

def show
	@category = Category.find(params[:id])

	if @category

		respond_to do |format|
			format.json { render json: @category }
			format.html
		end

	else

		respond_to do |format|
			format.json {render nothing: true, status: :no_content }
			format.js { render 'alert("Category not found!")', status: :no_content }
		end

	end

end

def edit
	@category = Category.find(params[:id])
end

private
def category_params
	params.require(:category).permit(:name, :description)
end

def get_categories
	
	@categories = Category.all.page(params[:page]).per_page(10)
	
end


def sortable_columns
	@sortable_columns = Category.column_names
	exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
	@sortable_columns -= exclusive_columns 
end

def upload_image(uploaded_file, image_filename)
	File.open(Rails.root.join('app', 'assets', 'images', 'uploads', 'categories', image_filename), 'wb') do |file|
		file.write(uploaded_file.read)
	end
end
end
