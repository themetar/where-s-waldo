class Scene < ApplicationRecord
  has_many :character_locations, dependent: :destroy
end
