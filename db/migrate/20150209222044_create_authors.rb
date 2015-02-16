class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
    	t.string 'first_name', null: false, limit: 10
    	t.string 'last_name', null:false, limit: 20
    	t.string 'preferred_name', limit: 20
    	t.string 'nationality', null: false, limit:15
		t.string 'tel', limit: 24
		t.string 'mobile', limit:24
		t.string 'email'
		t.string 'city', limit: 15
		t.string 'suburb', limit: 15
		t.string 'street', limit:60
		t.integer 'postal_code', limit:4
		t.timestamps null: false
    end
  end
end
