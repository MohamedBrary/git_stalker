class CreateReleases < ActiveRecord::Migration[6.0]
  def change
    create_table :releases do |t|
      t.references :git_update, null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true
      t.references :releaser, null: false, foreign_key: {to_table: :users}
      t.string :ticket_ids, array: true
      t.string :external_id
      t.timestamp :released_at
      t.string :tag_name
      t.string :state

      t.timestamps
    end
    add_index :releases, :ticket_ids, using: 'gin'
  end
end
