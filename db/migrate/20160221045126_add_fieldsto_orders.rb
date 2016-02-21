class AddFieldstoOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :timestamp, :string
	add_column :orders, :instructions, :text
	add_column :orders, :error_message, :text
  end
end
