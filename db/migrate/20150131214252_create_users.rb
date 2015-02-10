class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
    	t.string 'first_name', null: false, limit: 25
    	t.string 'last_name', null:false, limit: 25
    	t.string 'preferred_name', limit: 25
    	t.string 'email', null: false
    	t.string 'password', null: false, limit: 40
      t.string 'city', limit: 255
      t.string 'suburb', limit: 255
      t.string 'street', limit:255
      t.integer 'postal_code', limit:4
      t.integer 'tel'
      t.integer 'mobile'
    	t.timestamps null: false
    end
    add_index('users', 'email')
  end

  def down
  	drop_table :users
  end

end
