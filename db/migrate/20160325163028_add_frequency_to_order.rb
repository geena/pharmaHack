class AddFrequencyToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :frequency, :text
  end
end
