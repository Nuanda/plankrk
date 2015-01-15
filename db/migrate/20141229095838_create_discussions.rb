class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :fid, null: false
      t.string  :title
      t.belongs_to :author, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :discussions, :users, column: :author_id
    add_index :discussions, :created_at, order: { created_at: :desc }
  end
end
