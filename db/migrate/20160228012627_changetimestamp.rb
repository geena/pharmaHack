class Changetimestamp < ActiveRecord::Migration
  def up
    change_column :orders, :timestamp, :datetime
  end

  def down
    change_column :orders, :timestamp, :string
  end
end
