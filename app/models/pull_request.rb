class PullRequest < ApplicationRecord

  # ---------
  # Constants

  STATE_CREATED = 'created'.freeze
  STATE_APPROVED = 'approved'.freeze
  STATE_CLOSED = 'closed'.freeze
  STATES = [STATE_CREATED, STATE_APPROVED, STATE_CLOSED].freeze

  # ---------
  # Relations

  belongs_to :repository
  belongs_to :creator, class_name: 'User', optional: true
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :closer, class_name: 'User', optional: true

  def commits
    Commit.where("'#{id}' = ANY (pull_request_ids)")
  end

  # ------
  # Scopes

  scope :with_statuses, -> (statuses) { where(status: statuses) }
  scope :created, -> { with_statuses([STATE_PUSHED]) }
  scope :approved, -> { with_statuses([STATE_APPROVED]) }
  scope :closed, -> { with_statuses([STATE_CLOSED]) }

  # -----------
  # Validations

  validates :state, inclusion: { in: STATES }
  # TODO rest of validations

  # ----
  # Core

  # based on pull request commits
  def update_ticket_ids
    self.ticket_ids = commits.pluck(:ticket_ids).flatten.uniq
    save
  end


  # -------
  # Helpers

  def created?
    state == STATE_CREATED
  end

  def approved?
    state == STATE_APPROVED
  end

  def closed?
    state == STATE_CLOSED
  end

end
