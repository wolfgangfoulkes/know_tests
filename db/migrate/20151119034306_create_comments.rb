class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :default => "" 
      t.text :comment
      t.references :root, :polymorphic => true
      t.references :commentable, :polymorphic => true
      t.references :user
      t.string :role, :default => "default"
      t.boolean :public, :default => false
      t.timestamps
    end

    add_index :comments, :root_type
    add_index :comments, :root_id
    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end

  def self.down
    drop_table :comments
  end
end
