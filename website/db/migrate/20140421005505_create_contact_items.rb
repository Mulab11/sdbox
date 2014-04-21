class CreateContactItems < ActiveRecord::Migration
  def change
    create_table :contact_items do |t|
      t.string :address, :null => false
      t.string :name
      t.integer :platform_id
      t.integer :contact_id

      t.timestamps
    end
  end
end
