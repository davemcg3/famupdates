class Profile < ApplicationRecord
  has_and_belongs_to_many :user
  has_many :statuses, dependent: :destroy
  has_one :latest_status, -> { Status.latest_statuses_for_profiles }, class_name: "Status"
  has_many :posts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_exclusions, class_name: "Exclusion", foreign_key: "blocker_id", dependent: :destroy
  has_many :blocking, through: :active_exclusions, source: :blocked
  has_many :passive_exclusions, class_name: "Exclusion", foreign_key: "blocked_id", dependent: :destroy
  has_many :blockers, through: :passive_exclusions, source: :blocker

  validates :username, presence: true, uniqueness: true

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Blocks a user.
  def block(other_user)
    active_exclusions.create(blocked_id: other_user.id)
  end

  # Unfollows a user.
  def unblock(other_user)
    active_exclusions.find_by(blocked_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def blocking?(other_user)
    blocking.include?(other_user)
  end

  # TODO: make unblocked a scope and use it in the following_and_unblocked below
  def unblocked
    blockers_ids = blockers&.pluck(:id)
    blockers_ids.push(id)
    blockers_ids.blank? ? Profile.all : Profile.all.where.not(id: blockers_ids)
  end

  def following_and_unblocked
    blockers_ids = blockers&.pluck(:id)
    blocking_ids = blocking&.pluck(:id)
    blocked_ids = blockers_ids.union(blocking_ids)
    blocked_ids.blank? ? following : following.where.not(id: blocked_ids)
  end

  def all_not_blocked
    blockers_ids = blockers&.pluck(:id)
    blocking_ids = blocking&.pluck(:id)
    blocked_ids = blockers_ids.union(blocking_ids)
    blocked_ids.blank? ? Profile.all : Profile.all.where.not(id: blocked_ids)
  end

  scope :alphabetized_asc, -> { order(name: :asc) }
  scope :alphabetized_desc, -> { order(name: :desc) }
end
