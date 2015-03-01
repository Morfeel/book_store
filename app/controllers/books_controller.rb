class BooksController < ApplicationController

	before_action :require_login

	before_action :sortable_columns

	def index
		@books = Book.all.page(params[:page]).per_page(10)

		respond_to do |format|
			format.html
			format.json { render json: @books }
			format.js
		end
	end

	def destroy
		@book = Book.find(params[:id])
		if @book.destroy
			redirect_to action: 'index', status: 303
		else
			render nothing: true, status: :unprocessable_entity
		end
	end

	def create
		@book = Book.new(book_params)

		if params[:image].present?
			uploaded_file = params[:image]
			image_filename = File.split(uploaded_file.path).last
			upload_image uploaded_file, image_filename
			@book.image = image_filename
		end

		if @book.save
			respond_to do |format|
				format.html { render 'show'}
				format.json { render json: {id: session[:book_id], name: session[:name], can_admin: session[:can_admin]} }
				format.js { render 'updated' }
			end
		else
			respond_to do |format|
				format.json { render json: @book.errors, status: :unprocessable_entity }
				format.js { render 'register_error', status: :unprocessable_entity }
			end
		end

	end

	def new
		@book = Book.new
		render 'edit'
	end

	def update
		@book = Book.find(params[:id])


		if @book
			if params[:image].present?
				uploaded_file = params[:image]
				image_filename = File.split(uploaded_file.path).last
				upload_image uploaded_file, image_filename
				@book.image = image_filename
			end

			if params[:supplier].present?
				supplier = Supplier.find_by_name(params[:supplier])
				supplier.books << @book if supplier
			end

			if params[:publisher].present?
				publisher = Publisher.find_by_name(params[:publisher])
				publisher.books << @book if publisher
			end

			if @book.update_attributes(book_params)
				respond_to do |format|
					format.html { render 'show'}
					format.json { render json: {id: session[:book_id], name: session[:name], can_admin: session[:can_admin]} }
					format.js { render 'updated' }
				end
			else
				render js: 'alert("Cannot modify book")', status: :internal_server_error
			end
		else
			render js: 'alert("Book not found!")'
		end
	end

	def show
		@book = Book.find(params[:id])

		get_categories

		if @book

			respond_to do |format|
				format.json { render json: @book }
				format.html
			end

		else

			respond_to do |format|
				format.json {render nothing: true, status: :no_content }
				format.js { render 'alert("Book not found!")', status: :no_content }
			end

		end

	end

	def edit
		@book = Book.find(params[:id])
		get_categories	
	end

	def update_categories

		if params[:id]
			@book = Book.find(params[:id])
			@categories_string = params[:categories] if params[:categories].present?
			@book.categories = store_categories

			get_categories
			if @book.save
				respond_to do |format|
					format.js
				end
			end
		end
	end

	def update_authors

		if params[:id]
			@book = Book.find(params[:id])
			@authors_string = params[:authors] if params[:authors].present?
			@book.authors = store_authors

			if @book.save
				respond_to do |format|
					format.js
				end
			end
		end
	end

	private

	def get_categories
		@categories = @book.categories.map {|cat| cat.name}
		@suggestions = Category.all.map{|cat| cat.name.downcase} - @categories.map{|cat| cat.downcase}
	end

	def store_categories

		@categories = []
		if @categories_string

			@categories_array = (@categories_string.split(',').map{|cat| cat.chomp.capitalize}).uniq 

			@categories_array.each do |cat|

				unless Category.find_by_name(cat).blank?
					@categories << Category.find_by_name(cat)
				end
			end
		end
		@categories_string = @categories.map{|cat| cat.name.capitalize}.join(',')
		return @categories

	end

	def store_authors

		@authors = []
		if @authors_string

			@authors_array = (@authors_string.split(',').map{|author| author.chomp.capitalize}).uniq 

			@authors_array.each do |author|

				unless Author.find_by_preferred_name(author).blank?
					@authors << Author.find_by_preferred_name(author)
				end
			end
		end
		@authors_string = @authors.map{|author| author.preferred_name.capitalize}.join(',')
		return @authors

	end

	def book_params
		params.require(:book).permit(:name, :isbn, :price, :stock, :description, :paperback, :language,:category_id)
	end


	def sortable_columns
		@sortable_columns = Book.column_names
		exclusive_columns = ["preferred_name", "email", "password", "password_digest", "hashed_password", "city", "suburb", "street", "postal_code", "tel", "mobile", "group_id", "created_at", "updated_at"]
		@sortable_columns -= exclusive_columns 
	end

	def upload_image(uploaded_file, image_filename)
		File.open(Rails.root.join('app', 'assets', 'images', 'uploads', 'books', image_filename), 'wb') do |file|
			file.write(uploaded_file.read)
		end
	end
end
