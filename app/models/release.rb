class Release < ApplicationRecord

  # ---------
  # Relations
  belongs_to :git_update
  belongs_to :repository
  belongs_to :releaser, class_name: 'User'
  has_many :commits

  # ----
  # Core

  # based on release commits
  def update_ticket_ids
    self.ticket_ids = commits.pluck(:ticket_ids).flatten.uniq
    save
  end

end
