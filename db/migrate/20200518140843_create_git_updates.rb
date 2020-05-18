class CreateGitUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :git_updates do |t|
      t.references :user, null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true
      t.string :event
      t.string :external_source
      t.json :payload

      t.timestamps
    end
  end
end
