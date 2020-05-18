class CreatePullRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :pull_requests do |t|
      t.string :git_update_ids
      t.references :repository, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.references :approver, null: false, foreign_key: {to_table: :users}
      t.references :closer, null: false, foreign_key: {to_table: :users}
      t.string :external_id
      t.string :ticket_ids, array: true
      t.string :state

      t.timestamps
    end
    add_index :pull_requests, :ticket_ids, using: 'gin'
  end
end
