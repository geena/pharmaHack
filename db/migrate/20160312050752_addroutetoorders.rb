class Addroutetoorders < ActiveRecord::Migration
  def change
  	add_column :orders, :route, :string
  end
end
