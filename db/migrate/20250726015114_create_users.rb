class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :user_name, null: false
      t.string :full_name
      t.string :status, null: false, default: 'active'

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :user_name, unique: true
    add_index :users, :status
    
  end
end
