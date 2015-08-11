class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :event, index: true
      t.string :subject
      t.string :content

      t.timestamps
    end
  end
end
