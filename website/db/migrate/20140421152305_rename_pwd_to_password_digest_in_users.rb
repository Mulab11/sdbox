class RenamePwdToPasswordDigestInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :pwd, :password_digest
  end
end
