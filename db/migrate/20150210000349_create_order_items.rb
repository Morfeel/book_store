class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
    	t.references :order
    	t.references :book
    	t.integer 'quantity'
    	t.timestamps null: false
    end
    add_index :order_items, ['order_id', 'book_id']
  end
end
