class GameEvent < ApplicationRecord
  belongs_to :user

  validates :game_name, :occurred_at, :event_type, presence: true
end