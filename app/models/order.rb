class Order < ActiveRecord::Base

	belongs_to :user
	has_many :order_items
	has_many :books, :through => 'order_item'
end
