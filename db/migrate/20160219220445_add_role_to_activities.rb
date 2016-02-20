class AddRoleToActivities < ActiveRecord::Migration
  def change
  	change_table :activities do |t|
      t.string :role
    end
  end
end
