class AddAdminRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_rank, :integer
  end
end
