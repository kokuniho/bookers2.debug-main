class RemoveBookIdFromTagmap < ActiveRecord::Migration[6.1]

  def down
    remove_column :tagmaps, :book_id, :integer
  end

end
