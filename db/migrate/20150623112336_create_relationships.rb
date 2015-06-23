class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
    #polymorphic, so need _id and _type
      t.integer :follower_id
      t.string :follower_type

      t.integer :followed_id
      t.string :followed_type

      t.timestamps
    end

    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    #assure follower doesn't follow followed more than once
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
