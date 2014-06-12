class ChangePlatformToken < ActiveRecord::Migration
  def change
    change_table :platforms do |t|
      t.change :token, :text
    end
  end
end
