class ProfilePolicy < ApplicationPolicy
  def creator_is_actor?
    record == user.profiles.first
  end

  def update?
    creator_is_actor?
  end

  def destroy?
    creator_is_actor?
  end
end
