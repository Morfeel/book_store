class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
    	t.string 'first_name', null: false, limit: 25
    	t.string 'last_name', null:false, limit: 25
    	t.string 'nationality'
		t.integer 'tel'
		t.integer 'mobile'
		t.string 'email'
		t.string 'city', limit: 255
		t.string 'suburb', limit: 255
		t.string 'street', limit:255
		t.integer 'postal_code', limit:4
		t.string 'contactor'
		t.timestamps null: false
    end
  end
end
