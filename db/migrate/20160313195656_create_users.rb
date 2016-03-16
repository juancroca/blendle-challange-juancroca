class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :access_token
      t.string :password_digest
      t.timestamps
    end

    add_index :users, :access_token, unique: true
  end
end
