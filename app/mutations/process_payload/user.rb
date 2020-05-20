# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::User < Mutations::Command
  required do
    string :id
    string :name
    string :email
  end

  def execute
    # TODO do any email/name normalization
    {
      name: name,
      email: email,
      external_id: id,
      external_source: 'Future Feature'
    }
  end
end
