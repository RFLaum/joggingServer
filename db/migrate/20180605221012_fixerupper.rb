class Fixerupper < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :created_at
    remove_column :users, :updated_at
    add_index :users, :username
    add_index :jogs, :date
  end
end
