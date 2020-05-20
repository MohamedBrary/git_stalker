module Upsert::GitUpdates::Helpers

  def user
    @user ||= Upsert::User.run(raw_inputs[:processed_user]).result
  end

  def repository
    @repository ||= Upsert::Repository.run(raw_inputs[:processed_repository]).result
  end

  def git_update
    @git_update ||= GitUpdate.create(git_update_params)
  end

  def git_update_params
    {
      event: event,
      repository: repository,
      user: user,
      external_source: 'Future Feature',
      payload: raw_inputs[:payload]
    }
  end

  def create_commits
    commits
  end

  def commits
    @commits ||= Upsert::Commits.run(commits_params).result
  end

end
