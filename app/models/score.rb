class Score < ApplicationRecord
  belongs_to :scene
  validates :player_name, presence: true,
                          length: { minimum: 1, maximum: 140 }
  validates :time, presence: true
end
