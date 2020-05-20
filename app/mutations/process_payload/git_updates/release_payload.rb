# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::GitUpdates::ReleasePayload < Mutations::Command
  required do
    hash :repository
    string :action #, in: Release::STATES TODO handle states of release
    time :released_at
    hash :release
  end

  def execute
    {
      event: GitUpdate::EVENT_RELEASE,
      processed_user: processed_user,
      processed_repository: processed_repository,
      processed_release: processed_release,
      processed_commits: processed_commits,
      payload: raw_inputs
    }
  end

  def processed_repository
    @processed_repository ||= ProcessPayload::Repository.run(raw_inputs[:repository]).result
  end

  def processed_release
    @processed_release ||= ProcessPayload::Release.run(
      raw_inputs[:release].merge(released_at: released_at, action: action)
    ).result
  end

  def processed_commits
    ProcessPayload::Commits.run(commits: raw_inputs[:release][:commits]).result
  end

  def processed_user
    processed_release[:processed_user]
  end

end
