class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :patient_name
      t.string :order_name
      t.string :status
      t.string :dosage

      t.timestamps
    end
  end
end
