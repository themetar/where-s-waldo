# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Scene.destroy_all

beach = Scene.create({title: "On the beach", asset_name: "waldo-1.jpg"})
beach.character_locations.create({character: :odlaw,  x: 258,   y: 534})
beach.character_locations.create({character: :wizard, x: 684,   y: 532})
beach.character_locations.create({character: :waldo,  x: 1598,  y: 574})
beach.character_locations.create({character: :wenda,  x: 2004,  y: 627})
