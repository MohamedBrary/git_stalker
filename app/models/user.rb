class User < ApplicationRecord

  # ---------
  # Relations
  has_many :authored_commits, foreign_key: 'committer_id', class_name: 'Commit'
  has_many :pushed_commits, foreign_key: 'puher_id', class_name: 'Commit'

  has_many :created_pull_requests, foreign_key: 'creator_id', class_name: 'PullRequest'
  has_many :approved_pull_requests, foreign_key: 'approver_id', class_name: 'PullRequest'
  has_many :closed_pull_requests, foreign_key: 'closer_id', class_name: 'PullRequest'

  has_many :releases, foreign_key: 'releaser_id'

end
