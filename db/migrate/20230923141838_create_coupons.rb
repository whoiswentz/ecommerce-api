class CreateCoupons < ActiveRecord::Migration[7.0]
  def change
    create_enum :coupon_status, [:active, :inactive]

    create_table :coupons do |t|
      t.string :name
      t.string :code
      t.enum :coupon_status, enum_type: "coupon_status", default: :inactive, null: false
      t.decimal :discount_value, precision: 5, scale: 2
      t.integer :max_use
      t.datetime :due_date

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
