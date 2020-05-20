class GitUpdate < ApplicationRecord

  # ---------
  # Constants

  EVENT_PUSH = 'push'.freeze
  EVENT_PULL_REQUEST_ACTION = 'pull_request_action'.freeze
  EVENT_RELEASE = 'release'.freeze
  EVENTS = [EVENT_PUSH, EVENT_PULL_REQUEST_ACTION, EVENT_RELEASE].freeze

  # ---------
  # Relations
  belongs_to :user
  belongs_to :repository

end
