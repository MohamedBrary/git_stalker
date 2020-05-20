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
  belongs_to :release, optional: true
  belongs_to :committer, class_name: 'User'
  belongs_to :pusher, class_name: 'User', optional: true

  # ------
  # Scopes

  scope :with_statuses, -> (statuses) { where(status: statuses) }
  scope :pushed, -> { with_statuses([STATE_PUSHED]) }
  scope :released, -> { with_statuses([STATE_RELEASED]) }

  # -----------
  # Validations

  validates :state, inclusion: { in: STATES }
  # TODO rest of validations

  # ---------
  # Callbacks

  before_save :set_ticket_ids

  def set_ticket_ids
    self.ticket_ids = extract_ticket_ids if message_changed?
  end

  validates :state, inclusion: { in: STATES }
  # TODO rest of validations

  # -------
  # Helpers

  # message: ... Ref: #sp-421, #eve-421
  def extract_ticket_ids
    tickets = message.split('Ref: ').last
    tickets.gsub('#', '').split(',').map(&:strip)
  end

  def pushed?
    state == STATE_PUSHED
  end

  def released?
    state == STATE_RELEASED
  end

end
