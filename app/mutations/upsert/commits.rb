
class Upsert::Commits < Mutations::Command
  required do
    array :commits
    model :git_update
    model :repository
  end

  optional do
    model :pull_request
    model :release
    model :pusher, class: User
  end

  def execute
    raw_inputs[:commits].map do |commit|
      Upsert::Commit.run(commit.merge(
        git_update: git_update,
        repository: repository,
        pusher: pusher,
        release: release,
        pull_request: pull_request
      )).result
    end
  end

end
