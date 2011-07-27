class AddSaltToManagers < ActiveRecord::Migration
  def self.up
    add_column :managers, :salt, :string
  end

  def self.down
    remove_column :managers, :salt
  end
end
