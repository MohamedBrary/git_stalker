
class Upsert::Commit < Mutations::Command
  required do
    string :sha
    string :message
    time :pushed_at
    hash :processed_user do
      string :external_id
      string :name
      string :email
      string :external_source
    end
    model :git_update
    model :repository
  end

  optional do
    model :pull_request
    model :release
    model :pusher, class: User
  end

  def execute
    commit = Commit.where(repository_id: repository.id, sha: sha).first

    if commit.present?
      commit.pull_request_ids = (commit.pull_request_ids << pull_request.id.to_s).uniq if pull_request_present?
      commit.release_id = release.id if release_present?
      commit.pusher_id = pusher.id if pusher_present?
      commit.state = commit_state
      commit.save
    else
      commit_params = inputs.except(:processed_user, :pull_request).merge(committer: committer)
      commit_params[:pull_request_ids] = [pull_request.id] if pull_request_present?
      commit = Commit.create(commit_params.merge(state: commit_state))
    end

    commit
  end

  def committer
    @committer ||= Upsert::User.run(processed_user).result
  end

  def commit_state
    # TODO support more states based on PullRequest states
    release_present? ? Commit::STATE_RELEASED : Commit::STATE_PUSHED
  end

end
