class AddUidToPlatform < ActiveRecord::Migration
  def change
    add_column :platforms, :uid, :string
  end
end
