class AddImageToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :image, :string
  end
end
