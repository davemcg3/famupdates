class Status < ApplicationRecord
  belongs_to :profile

  def self.latest_statuses_for_profiles
    latest_statuses_ids = select("max(id)").group(:profile_id)
    where(id: latest_statuses_ids)
  end
end
