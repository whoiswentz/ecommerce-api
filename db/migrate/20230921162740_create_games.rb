class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_enum :game_mode, %w[pvp pve both]

    create_table :games do |t|
      t.enum :mode, enum_type: "game_mode", default: "both", null: false
      t.datetime :release_date
      t.string :developer
      t.references :system_requirement, null: false, foreign_key: true

      t.timestamps
    end
  end
end
