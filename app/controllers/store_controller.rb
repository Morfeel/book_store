class StoreController < ApplicationController

	before_action :require_login, only: [:add]

	def index
		@books = Book.all
	end

	def show
		@book = Book.find(params[:id])
	end

	def add
		@book = Book.find(params[:id])

		

			session[:order_items] = {} unless session[:order_items].present?
			
			item = OrderItem.new(item_params)

			if session[:order_items][item.book_id.to_s].present?
				session[:order_items][item.book_id.to_s] += item.quantity

			else
				session[:order_items][item.book_id.to_s] = item.quantity
			end

			get_items

			respond_to do |format|
				format.js {render 'added'}
			end
	
		
	end

	def cart
		if session[:order_items].present?

			@order_items = []

			session[:order_items].each do |key, qty|
				item = OrderItem.new
				book = Book.find(key)
				puts book
				item.book = book
				item.quantity = qty
				@order_items << item
			end
		end

	end

	def update_quantity
		if session[:order_items][params[:id].to_s].present?

			if params[:add].present?
				session[:order_items][params[:id].to_s] += 1
			elsif params[:minus].present?
				session[:order_items][params[:id].to_s] -= 1
				if session[:order_items][params[:id].to_s] < 1
					session[:order_items].delete params[:id].to_s
				end
			elsif params[:quantity].present?
				if params[:quantity] > 0
					session[:order_items][params[:id].to_s] = params[:quantity]
				end
			end
			
		end
		get_items

		respond_to do |format|
			format.js
		end		
	end

	def clear_cart
		session[:order_items] = nil
		respond_to do |format|
			format.js {render 'update_quantity'}
		end
	end

	def place_order
		if session[:user_id].present?
			if session[:order_items].present? && !session[:order_items].empty?
				user = User.find(session[:user_id])
				order = Order.new
				order.user = user
				get_items
				order.order_items = @order_items
				if order.save
					redirect_to root_path
					session[:order_items] = nil
				else
				end

			else
			end

		else

		end
	end

	private

	def item_params
		params.require(:order_item).permit(:book_id, :quantity)	
	end
	
end
