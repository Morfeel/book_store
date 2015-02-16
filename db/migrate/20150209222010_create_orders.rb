class CreateOrders < ActiveRecord::Migration
  def up
    create_table :orders do |t|
    	t.references :user, null: false
      t.timestamps null: false
    end
    add_index('orders', 'user_id')
  end

  def down
  	drop_table :orders
  end
end
