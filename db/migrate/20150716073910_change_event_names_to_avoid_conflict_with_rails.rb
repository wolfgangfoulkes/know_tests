class ChangeEventNamesToAvoidConflictWithRails < ActiveRecord::Migration
  def change
  	change_table :events do |t|
  		t.rename :start, :starts_at
  		t.rename :end, :ends_at
  	end
  end
end
