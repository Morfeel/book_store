class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
    	t.string 'first_name', null: false, limit: 10
    	t.string 'last_name', null:false, limit: 20
    	t.string 'preferred_name', limit: 20
    	t.string 'email', null: false
    	t.string 'password', limit: 40
      t.string 'password_digest'
      t.string 'hashed_password', limit: 40
      t.string 'city', limit: 15
      t.string 'suburb', limit: 15
      t.string 'street', limit: 60
      t.integer 'postal_code', limit:4
      t.string 'tel', limit: 24
      t.string 'mobile', limit: 24
      t.references :group
    	t.timestamps null: false
    end
    add_index('users', 'email')
    add_index('users', 'group_id')
  end

  def down
  	drop_table :users
  end

end
