class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, index: { unique: true, name: "unique_categories" }

      t.timestamps
    end
  end
end
