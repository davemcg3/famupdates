class Post < ApplicationRecord
  attr :author_profile

  belongs_to :profile

  scope :by_user, lambda { |user|
    where(:profile_id => user.id)
  }

  def author
    author_profile || Profile.find(self.author_id) # TODO: consider changing to find_by_id so you don't throw exceptions
  end
end
