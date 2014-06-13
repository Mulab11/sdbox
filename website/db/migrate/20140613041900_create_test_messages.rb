class CreateTestMessages < ActiveRecord::Migration
  def change
    create_table :test_messages do |t|
      t.string :source
      t.string :target
      t.text :full_text
      t.integer :status
    end
  end
end
