class RemoveGoogleParamsFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :uid
  	remove_column :users, :provider
  	remove_column :users, :token
  end
end
