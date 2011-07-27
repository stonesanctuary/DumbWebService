class AddPasswordToManagers < ActiveRecord::Migration
  def self.up
    add_column :managers, :encrypted_password, :string
  end

  def self.down
    remove_column :managers, :encrypted_password
  end
end
