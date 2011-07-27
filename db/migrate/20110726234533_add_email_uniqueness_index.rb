class AddEmailUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :managers, :email, :unique => true
  end

  def self.down
    remove_index :managers, :email
  end
end
