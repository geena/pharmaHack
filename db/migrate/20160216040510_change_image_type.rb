class ChangeImageType < ActiveRecord::Migration
  def self.up
    change_column :orders, :image, :text
  end
 
  def self.down
    change_column :orders, :image, :string
  end
end