class CreateStreetCommunes < ActiveRecord::Migration[5.0]
  def change
    create_table :street_communes do |t|
      t.integer :street_id
      t.integer :commune_id

      t.timestamps
    end
  end
end
