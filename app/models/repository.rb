class Repository < ApplicationRecord

  # ---------
  # Relations
  has_many :commits
  has_many :pull_requests
  has_many :releases
end
