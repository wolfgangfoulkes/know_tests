class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :commentable, polymorphic: true, index: true
      t.string :subject
      t.string :content

      t.timestamps
    end
  end
end
