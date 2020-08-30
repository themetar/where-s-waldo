class CreateCharacterLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :character_locations do |t|
      t.string :character
      t.references :scene, foreign_key: true
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
