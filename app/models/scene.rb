class Scene < ApplicationRecord
  has_many :character_locations, dependent: :destroy
  has_many :scores, dependent: :destroy
end
