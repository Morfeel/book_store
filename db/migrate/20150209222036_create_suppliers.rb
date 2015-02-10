class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
    	t.string 'name'
		t.integer 'tel'
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
