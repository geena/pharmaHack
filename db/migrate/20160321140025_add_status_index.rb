class AddStatusIndex < ActiveRecord::Migration
  def change
  	add_index(:orders, :status)
  end
end
