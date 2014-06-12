class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :contact_item_id
      t.datetime :receive_time
      t.integer :status
      t.string :full_text

      t.timestamps
    end
  end
end
