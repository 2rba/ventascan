class CreateVentaCityMap < ActiveRecord::Migration
  def change
    create_table :venta_city_maps do |t|
      t.string :city_name,  :null => false
      t.string :city_id,  :null => false
    end
    add_index :venta_city_maps, :city_name, :unique => true
    add_index :venta_city_maps, :city_id, :unique => true
  end
end
