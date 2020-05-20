# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::Commit < Mutations::Command
  required do
    string :sha
    string :message
    time :date
    hash :author do
      string :id
      string :name
      string :email
    end
  end

  def execute
    {
      sha: sha,
      message: message,
      pushed_at: date,
      processed_user: processed_user
    }
  end

  def processed_user
    ProcessPayload::User.run(author).result
  end

end
