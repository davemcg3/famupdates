class StatusPolicy < ApplicationPolicy
  def creator_is_actor?
    record.profile == user.profiles.first
  end

  def update?
    creator_is_actor?
  end

  def destroy?
    creator_is_actor?
  end
end
