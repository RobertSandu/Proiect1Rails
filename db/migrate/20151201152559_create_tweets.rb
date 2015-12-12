class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :title
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_foreign_key :tweets, :users
    add_index :tweets, [:user_id, :created_at]
  end
end
