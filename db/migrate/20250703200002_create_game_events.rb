class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.string :game_name
      t.datetime :occurred_at
      t.string :event_type
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
