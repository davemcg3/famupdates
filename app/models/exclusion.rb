# a profile has followers or users they are following through this relationship
class Exclusion < ApplicationRecord
  belongs_to :blocker, class_name: "Profile"
  belongs_to :blocked, class_name: "Profile"
  validates :blocker_id, presence: true
  validates :blocked_id, presence: true
end
