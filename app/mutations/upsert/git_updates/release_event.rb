
class Upsert::GitUpdates::ReleaseEvent < Mutations::Command
  include Upsert::GitUpdates::Helpers

  required do
    string :event
    hash :processed_user
    hash :processed_repository
    hash :processed_release
    array :processed_commits
    hash :payload
  end

  def execute
    # TODO handle error propagation
    # we create release first to pass its id to the commits
    create_commits

    # then update ticket ids based on release commits
    release.update_ticket_ids

    # return git_update record
    git_update
  end

  def create_release
    release
  end

  def release
    @release ||= Upsert::Release.run(release_params).result
  end

  def release_params
    raw_inputs[:processed_release].merge(
      git_update: git_update,
      repository: repository,
      releaser: user
    )
  end

  def commits_params
    {
      commits: raw_inputs[:processed_commits],
      git_update: git_update,
      repository: repository,
      release: release
    }
  end

end
