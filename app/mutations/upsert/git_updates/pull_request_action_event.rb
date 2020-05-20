
class Upsert::GitUpdates::PullRequestActionEvent < Mutations::Command
  include Upsert::GitUpdates::Helpers

  required do
    string :event
    hash :processed_user
    hash :processed_repository
    hash :processed_pull_request
    array :processed_commits
    hash :payload
  end

  def execute
    # TODO handle error propagation
    # we create pull request first to pass its id to the commits
    create_commits

    # then update ticket ids based on pull request commits
    pull_request.update_ticket_ids

    # return git_update record
    git_update
  end

  def pull_request
    @pull_request ||= Upsert::PullRequest.run(pull_request_params).result
  end

  def pull_request_params
    raw_inputs[:processed_pull_request]
      .except(:processed_user)
      .merge(
        git_update: git_update,
        repository: repository,
        user: user
      )
  end

  def commits_params
    {
      commits: raw_inputs[:processed_commits],
      git_update: git_update,
      repository: repository,
      pull_request: pull_request
    }
  end

end
