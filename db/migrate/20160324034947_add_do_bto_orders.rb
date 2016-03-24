class AddDoBtoOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :dob, :string
  end
end
