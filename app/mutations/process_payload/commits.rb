# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::Commits < Mutations::Command
  required do
    array :commits
  end

  def execute
    raw_inputs[:commits].map do |commit|
      ProcessPayload::Commit.run(commit).result
    end
  end

end
