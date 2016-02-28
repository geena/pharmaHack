class Removeandddtimestamp < ActiveRecord::Migration
  def up
  	remove_column :orders, :timestamp
    add_column :orders, :timestamp, :datetime
  end

  def down
  	remove_column :orders, :timestamp
    add_column :orders, :timestamp, :string
  end
end
