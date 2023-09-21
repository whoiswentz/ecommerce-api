class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :sku, index: { unique: true, name: "unique_products_sku" }
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.references :producttable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
