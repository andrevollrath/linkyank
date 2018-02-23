class AddRankToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :rank, :integer
  end
end
