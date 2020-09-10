require "swearjar"

class Score < ApplicationRecord
  belongs_to :scene
  validates :player_name, presence: true,
                          length: { minimum: 1, maximum: 140 }
  validates :time, presence: true
  
  validate :player_name_cant_contain_bad_language

  private

    def player_name_cant_contain_bad_language
      sj = Swearjar.default
      if sj.profane?(player_name)
        errors.add(:player_name, "Please refrain from using bad language.")
      end
    end
end
