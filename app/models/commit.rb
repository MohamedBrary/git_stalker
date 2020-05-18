class Commit < ApplicationRecord

  # ---------
  # Constants

  STATE_PUSHED = 'pushed'.freeze
  STATE_RELEASED = 'released'.freeze
  STATES = [STATE_PUSHED, STATE_RELEASED].freeze

  # ---------
  # Relations

  belongs_to :git_update
  belongs_to :repository
  belongs_to :release
  belongs_to :committer, class_name: 'User'
  belongs_to :pusher, class_name: 'User'

  # ------
  # Scopes

  scope :with_statuses, -> (statuses) { where(status: statuses) }
  scope :pushed, -> { with_statuses([STATE_PUSHED]) }
  scope :released, -> { with_statuses([STATE_RELEASED]) }

  # -----------
  # Validations

  validates :state, inclusion: { in: STATES }
  # TODO rest of validations

  # -------
  # Helpers

  def pushed?
    state == STATE_PUSHED
  end

  def released?
    state == STATE_RELEASED
  end

end
