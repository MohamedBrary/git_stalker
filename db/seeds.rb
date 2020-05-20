# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

path = File.join(Rails.root, 'spec', 'fixtures', 'payloads')
payloads = ['pull_request_action', 'push_payload', 'release_payload']
payloads.each do |payload|
  payload_json = JSON.parse(File.open(File.join(path, "#{payload}.json")).read)
  payload_json.delete('expected_records')
  Upsert::GitUpdate.run(ProcessPayload::GitUpdate.run(payload_json).result)
end
