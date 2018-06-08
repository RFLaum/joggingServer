class CreateJogs < ActiveRecord::Migration[5.1]
  def change
    create_table :jogs do |t|
      t.references :user, foreign_key: true
      t.date :date
      t.integer :time
      t.float :distance
    end
  end
end
