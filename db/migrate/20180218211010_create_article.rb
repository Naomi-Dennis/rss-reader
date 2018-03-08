class CreateArticle < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do | col |
      col.string :title
      col.string :description
      col.string :link
      col.string :date
      col.integer :feed_id
    end
  end
end
