class ApplicationController < ActionController::Base
# Prevent CSRF attacks by raising an exception.
# For APIs, you may want to use :null_session instead.

before_action :get_items

def bitmap?(data)
	return data[0,2]=="MB"
end

def gif?(data)
	return data[0,4]=="GIF8"
end

def jpeg?(data)
	return data[0,4]=="\xff\xd8\xff\xe0"
end

def png?(data)
	return data[0,4]=="\xff\xfc\xfd\xfe"
end

def is_image?(filename)
f = File.open(filename,'rb')  # rb means to read using binary
data = f.read(9)              # magic numbers are up to 9 bytes
f.close
return (bitmap?(data) || gif?(data) || jpeg?(data) || png?(data))
end

def get_items
	@order_items = []
	if session[:order_items].present?

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

private
def require_login
		unless session[:user_id].present?
			respond_to do |format|
				format.html {render 'require_login'}
				format.js {render 'require_login'}
			end
		end	
	end

end
