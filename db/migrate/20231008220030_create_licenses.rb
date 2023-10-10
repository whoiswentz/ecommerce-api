class CreateLicenses < ActiveRecord::Migration[7.0]
  def change
    create_enum :license_status, [
      :used,
      :available,
      :canceled,
      :pending_creation,
      :pending_cancellation
    ]

    create_enum :license_platform, [
      :steam,
      :battle_net,
      :origin,
      :ps5,
      :xbox
    ]

    create_table :licenses do |t|
      t.string :key
      t.enum :license_platform, enum_type: "license_platform", null: false
      t.enum :license_status, enum_type: "license_status", default: :pending_creation

      t.references :game, null: false, foreign_key: true

      t.timestamps
    end

    add_index :licenses, [:key, :license_platform], unique: true
  end
end
