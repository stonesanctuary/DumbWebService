class AddAdminToManagers < ActiveRecord::Migration
  def self.up
    add_column :managers, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :managers, :admin
  end
end
