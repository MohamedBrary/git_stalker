class CreateRepositories < ActiveRecord::Migration[6.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :external_id
      t.string :external_source

      t.timestamps
    end
  end
end
