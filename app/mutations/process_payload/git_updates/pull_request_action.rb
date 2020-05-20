# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::GitUpdates::PullRequestAction < Mutations::Command
  required do
    hash :repository
    string :number
    hash :pull_request
  end

  def execute
    {
      event: GitUpdate::EVENT_PULL_REQUEST_ACTION,
      processed_user: processed_user,
      processed_repository: processed_repository,
      processed_pull_request: processed_pull_request,
      processed_commits: processed_commits,
      payload: raw_inputs
    }
  end

  def processed_repository
    @processed_repository ||= ProcessPayload::Repository.run(raw_inputs[:repository]).result
  end

  def processed_pull_request
    @processed_pull_request ||= ProcessPayload::PullRequest.run(raw_inputs[:pull_request]).result
  end

  def processed_commits
    ProcessPayload::Commits.run(commits: raw_inputs[:pull_request][:commits]).result
  end

  def processed_user
    processed_pull_request[:processed_user]
  end

end
