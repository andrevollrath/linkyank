class AddUrlToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :url, :string
  end
end
