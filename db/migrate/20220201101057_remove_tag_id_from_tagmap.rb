class RemoveTagIdFromTagmap < ActiveRecord::Migration[6.1]

  def down
    remove_column :tagmaps, :tag_id, :integer
    drop_table :tagmaps
  end

end
