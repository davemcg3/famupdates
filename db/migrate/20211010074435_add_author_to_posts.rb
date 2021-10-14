class AddAuthorToPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :author, index:true, foreign_key:{to_table: :profiles}
  end
end
