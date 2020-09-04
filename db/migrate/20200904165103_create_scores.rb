class CreateScores < ActiveRecord::Migration[5.2]
  def change
    create_table :scores do |t|
      t.string :player_name
      t.integer :time
      t.references :scene, foreign_key: true

      t.timestamps
    end
  end
end
