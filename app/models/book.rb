class Book < ActiveRecord::Base
	belongs_to :publisher
	belongs_to :supplier
	has_many :order_items
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :authors
	has_many :orders, :through => 'order_item'
end
