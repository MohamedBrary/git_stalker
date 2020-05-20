
class Upsert::GitUpdate < Mutations::Command

  def execute
    case git_update_params[:event]
    when GitUpdate::EVENT_PUSH
      Upsert::GitUpdates::PushEvent.run(git_update_params).result
    when GitUpdate::EVENT_PULL_REQUEST_ACTION
      Upsert::GitUpdates::PullRequestActionEvent.run(git_update_params).result
    when GitUpdate::EVENT_RELEASE
      Upsert::GitUpdates::ReleaseEvent.run(git_update_params).result
    end
  end

  def git_update_params
    # we recieve these params for now from our own mutations so it should be safe
    @git_update_params ||= raw_inputs
  end

end
