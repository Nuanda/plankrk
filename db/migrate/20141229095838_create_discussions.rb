class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :fid,     null: false
      t.string  :title

      t.timestamps null: false
    end
  end
end
