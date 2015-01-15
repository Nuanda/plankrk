class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.belongs_to :author, index: true, null: false
      t.belongs_to :discussion, index: true, null: false
      t.belongs_to :thread, index: true

      t.timestamps null: false
    end

    add_foreign_key :comments, :users, column: :author_id
    add_foreign_key :comments, :discussions
    add_index :comments, :created_at
  end
end
