class CreateUserShares < ActiveRecord::Migration[5.2]
  def change
    create_table :user_shares do |t|
      t.integer :role_id
      t.integer :user_id
      t.integer :note_id
      t.timestamps
    end
  end
end
