class AddSpecialtyToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :cspecialty, :string
  end
end
