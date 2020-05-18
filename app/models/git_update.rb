class GitUpdate < ApplicationRecord

  # ---------
  # Relations
  belongs_to :user
  belongs_to :repository

end
