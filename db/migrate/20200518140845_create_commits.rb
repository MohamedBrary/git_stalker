class CreateCommits < ActiveRecord::Migration[6.0]
  def change
    create_table :commits do |t|
      t.references :git_update, null: false, foreign_key: true
      t.references :repository, null: false, foreign_key: true
      t.references :release, null: true, foreign_key: true
      t.references :committer, null: true, foreign_key: {to_table: :users}
      t.references :pusher, null: true, foreign_key: {to_table: :users}
      t.timestamp :pushed_at
      t.string :pull_request_ids, array: true
      t.string :ticket_ids, array: true
      t.string :sha
      t.string :message
      t.string :state

      t.timestamps
    end
    add_index :commits, :ticket_ids, using: 'gin'
  end
end
