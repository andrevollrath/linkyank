class RemoveUrlFromMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :url, :string
  end
end
