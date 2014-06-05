class ChangeNameToUniqueInUsers < ActiveRecord::Migration
  def change
    change_column :users, :name, :string, :uniqueness => true
  end
end
