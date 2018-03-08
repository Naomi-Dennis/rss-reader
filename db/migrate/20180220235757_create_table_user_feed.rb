class CreateTableUserFeed < ActiveRecord::Migration[5.1]
  def change
    create_table :user_feeds do | col |
      col.integer :user_id
      col.integer :feed_id
    end
  end
end
