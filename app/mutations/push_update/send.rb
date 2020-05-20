class PushUpdate::Send < Mutations::Command
  require 'httparty'

  # https://webhook.site/#!/1a8aef30-f76d-45f9-8169-7c09d65eccce/3d0b808d-830a-47d1-be6d-4f646528313f/1
  DEFAULT_TARGET = 'https://webhook.site/1a8aef30-f76d-45f9-8169-7c09d65eccce'

  required do
    string :target_url, default: DEFAULT_TARGET
    hash :payload
  end

  def execute
    HTTParty.post(
      target_url,
      body: raw_inputs[:payload].to_json,
    )
  end
end
