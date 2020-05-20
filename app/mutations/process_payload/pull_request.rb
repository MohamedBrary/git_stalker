# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::PullRequest < Mutations::Command
  required do
    string :id
    string :number
    string :state, in: PullRequest::STATES
    hash :user do
      string :id
      string :name
      string :email
    end
  end

  def execute
    {
      external_id: number,
      state: state,
      processed_user: processed_user
    }
  end

  def processed_user
    ProcessPayload::User.run(user).result
  end

end
