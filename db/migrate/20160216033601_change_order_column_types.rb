class ChangeOrderColumnTypes < ActiveRecord::Migration
  def self.up
    change_column :orders, :order_name, :text
    change_column :orders, :dosage, :text
  end
 
  def self.down
    change_column :orders, :order_name, :string
    change_column :orders, :dosage, :string
  end
end
