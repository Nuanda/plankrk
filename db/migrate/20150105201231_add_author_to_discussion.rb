class AddAuthorToDiscussion < ActiveRecord::Migration
  def change
    add_column :discussions, :author_id, :integer
    add_foreign_key :discussions, :users, column: :author_id
  end
end
