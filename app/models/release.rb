class Release < ApplicationRecord

  # ---------
  # Relations
  belongs_to :git_update
  belongs_to :repository
  belongs_to :releaser, class_name: 'User'
  has_many :commits

end
