# takes an API payload, and returns the corresponding ActiveRecord hash
# this setup can be extended to handle different external services with different payloads
# while relations between objects would be handled in the Upsert mutations
# and we need to use raw_inputs for any nested resource, so each resource would handle its own validation TODO propagate errors to highest level
class ProcessPayload::GitUpdate < Mutations::Command

  def execute
    case payload_type
    when GitUpdate::EVENT_PUSH
      ProcessPayload::GitUpdates::PushPayload.run(input_payload).result
    when GitUpdate::EVENT_PULL_REQUEST_ACTION
      ProcessPayload::GitUpdates::PullRequestAction.run(input_payload).result
    when GitUpdate::EVENT_RELEASE
      ProcessPayload::GitUpdates::ReleasePayload.run(input_payload).result
    end
  end

  # detect which payload we are recieving here
  def payload_type
    if input_payload['commits'].present?
      GitUpdate::EVENT_PUSH
    elsif input_payload['pull_request'].present?
      GitUpdate::EVENT_PULL_REQUEST_ACTION
    elsif input_payload['release'].present?
      GitUpdate::EVENT_RELEASE
    end
  end

  def input_payload
    # TODO maybe add some light validations here, but we can rely on the sub mutations
    # to each handle its own payload
    @input_payload ||= raw_inputs
  end

end
