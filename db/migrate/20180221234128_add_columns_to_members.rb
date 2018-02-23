class AddColumnsToMembers < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :email_from, :string
    add_column :members, :email_date, :datetime
    add_column :members, :email_method, :string
    add_column :members, :cgeographic, :string
    add_column :members, :ccity, :string
    add_column :members, :cpostal, :string
    add_column :members, :curl, :string
    add_column :members, :cdescription, :text
  end
end
