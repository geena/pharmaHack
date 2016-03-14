class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :name
      t.string :dob
      t.text :allergies, array: true, default: []

      t.timestamps
    end
  end
end
