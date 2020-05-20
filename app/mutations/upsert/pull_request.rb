
class Upsert::PullRequest < Mutations::Command
  required do
    string :external_id
    string :state, in: PullRequest::STATES
    model :user
    model :git_update
    model :repository
  end

  def execute
    # TODO add external_source too so we can identify unique record
    pull_request = PullRequest.where(external_id: external_id).first

    if pull_request.present?
      # TODO handle conflicts if record exists, and new changes detected
      pull_request.git_update_ids = (pull_request.git_update_ids << pull_request.id.to_s).uniq
      pull_request.update(pull_request_updater)
    else
      pull_request_params = inputs.except(:user, :git_update).merge(pull_request_updater)
      pull_request_params[:git_update_ids] = [git_update.id]
      pull_request = PullRequest.create(pull_request_params)
    end

    pull_request
  end

  def pull_request_updater
    case state
    when PullRequest::STATE_CREATED
      {creator_id: user.id}
    when PullRequest::STATE_APPROVED
      {approver_id: user.id}
    when PullRequest::STATE_CLOSED
      {closer_id: user.id}
    end
  end
end
