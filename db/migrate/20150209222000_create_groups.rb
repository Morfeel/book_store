class CreateGroups < ActiveRecord::Migration
  def up
    create_table :groups do |t|
    	t.string 'name', null: false
    	t.text 'description'
      t.boolean 'can_login', default: false, null: false
      t.boolean 'can_order', default: false, null: false
      t.boolean 'can_admin', default: false, null: false
    	t.timestamps null: false
    end

    add_index('groups', 'name')
  end

  def down
  	drop_table :groups
  end
end
