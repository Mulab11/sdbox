class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :kind, :null => false
      t.string :token
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end
end
