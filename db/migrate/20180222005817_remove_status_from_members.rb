class RemoveStatusFromMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :status, :boolean
  end
end
