class CreateLicences < ActiveRecord::Migration[7.0]
  def change
    create_enum :licence_status, [
      :used,
      :available,
      :canceled,
      :pending_creation,
      :pending_cancellation
    ]

    create_enum :licence_platform, [
      :steam,
      :battle_net,
      :origin,
      :ps5,
      :xbox
    ]

    create_table :licences do |t|
      t.string :key
      t.enum :licence_status, enum_type: "licence_status", default: :pending_creation

      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
