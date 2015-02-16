class CreateBooks < ActiveRecord::Migration
  def up
    create_table :books do |t|
      t.references :supplier
      t.references :publisher
    	t.string 'name', limit: 40
    	t.string 'isbn', limit: 10
    	t.string 'image'
    	t.float 'price'
    	t.integer 'stock'
    	t.text 'description'
    	t.integer 'paperback'
    	t.string 'language'
      t.timestamps null: false
    end
    add_index('books', 'supplier_id')
    add_index('books', 'publisher_id')
  end

  def down
    drop_table :books
  end
end
