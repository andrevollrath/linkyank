class RemoveStatusAgainFromMembers < ActiveRecord::Migration[5.0]
  def change
    remove_column :members, :status, :integer
  end
end
