class CreateAuthorComments < ActiveRecord::Migration
  def change
    create_table :author_comments do |t|
      t.references :event, index: true, foreign_key: true
      t.string :subject
      t.string :content

      t.timestamps
    end
  end
end
