class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.text :description

      t.timestamps
    end

    add_index :books, :title
    add_index :books, :author
    add_index :books, [:title, :author], unique: true
  end
end
