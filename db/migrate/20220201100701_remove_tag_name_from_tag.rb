class RemoveTagNameFromTag < ActiveRecord::Migration[6.1]

  def down
    remove_column :tags, :ails, :string
    remove_column :tags, :tag_name, :string
  end
end
