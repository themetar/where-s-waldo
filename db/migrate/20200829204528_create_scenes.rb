class CreateScenes < ActiveRecord::Migration[5.2]
  def change
    create_table :scenes do |t|
      t.string :title
      t.string :asset_name

      t.timestamps
    end
  end
end
