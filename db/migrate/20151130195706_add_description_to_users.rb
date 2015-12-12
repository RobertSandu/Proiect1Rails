class AddDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :string, :limit => 5000
    add_column :users, :sex, :string
  end
end
