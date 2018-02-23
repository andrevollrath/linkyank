class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :name
      t.integer :nid
      t.string :email
      t.string :title
      t.string :location
      t.string :company
      t.integer :cid
      t.boolean :status

      t.timestamps
    end
  end
end
