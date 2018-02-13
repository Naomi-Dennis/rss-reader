class CreateFeed < ActiveRecord::Migration[5.1]
  def change
      create_table :feed do | col |
        col.string :url
        col.integer :user_id
      end
  end
end
