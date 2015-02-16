class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
    	t.string 'name', null: false, limit: 40
		t.string 'contact_name', limit: 30
		t.string 'contact_title', limit: 30
		t.string 'tel', limit: 24, null: false
		t.string 'email', null: false
		t.string 'city', limit: 15
		t.string 'suburb', limit: 15
		t.string 'street', limit:60
		t.integer 'postal_code', limit:4		
		t.timestamps null: false
    end
  end
end
