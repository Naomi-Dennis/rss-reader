class CreateFeed < ActiveRecord::Migration[5.1]
  def change
      create_table :feeds do | col |
        col.string :url
      end
  end
end
