class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do | col |
      col.string :username
      col.string :password
      col.string :email
    end
  end
end
