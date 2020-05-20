
class Upsert::GitUpdates::PushEvent < Mutations::Command
  include Upsert::GitUpdates::Helpers

  required do
    string :event
    hash :processed_user
    hash :processed_repository
    array :processed_commits
    hash :payload
  end

  def execute
    # TODO handle error propagation
    create_commits

    # return git_update record
    git_update
  end

  def commits_params
    {
      commits: raw_inputs[:processed_commits],
      git_update: git_update,
      repository: repository,
      pusher: user
    }
  end

end
