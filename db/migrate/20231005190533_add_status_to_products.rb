class AddStatusToProducts < ActiveRecord::Migration[7.0]
  def change
    create_enum :product_status, [:available, :out_of_stock]

    add_column :products, :product_status, :enum, enum_type: "product_status", default: :available, null: false
  end
end
