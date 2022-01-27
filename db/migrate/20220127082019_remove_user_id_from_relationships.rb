class RemoveUserIdFromRelationships < ActiveRecord::Migration[6.1]
  def up
    remove_column :relationships, :user_id, :integer
  end
end
