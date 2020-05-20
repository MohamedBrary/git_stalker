# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::GitUpdates::PushPayload < Mutations::Command
  required do
    hash :repository
    array :commits
    time :pushed_at
    hash :pusher
  end

  def execute
    {
      event: GitUpdate::EVENT_PUSH,
      processed_user: processed_pusher,
      processed_repository: processed_repository,
      processed_commits: processed_commits,
      payload: raw_inputs
    }
  end

  def processed_repository
    ProcessPayload::Repository.run(raw_inputs[:repository]).result
  end

  def processed_pusher
    ProcessPayload::User.run(raw_inputs[:pusher]).result
  end

  def processed_commits
    ProcessPayload::Commits.run(commits: raw_inputs[:commits]).result
  end

end
