class ChangeEventTimeNames < ActiveRecord::Migration
  def change
  	change_table :events do |t|
  		t.rename :starts_at, :start
  		t.rename :ends_at, :end
  	end
  end
end
