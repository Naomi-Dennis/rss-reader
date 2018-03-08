class AddFeedName < ActiveRecord::Migration[5.1]
  def change
    add_column :feeds, :name, :string
  end
end
