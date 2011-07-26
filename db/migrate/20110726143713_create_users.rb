class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :udid
      t.string :devtoken

      t.timestamps
    end
    
    add_index :users, :devtoken, :unique => true
    add_index :users, :udid, :unique => true
    
  end

  def self.down
    remove_index :users, :devtoken
    remove_index :users, :udid
    drop_table :users
  end
end
