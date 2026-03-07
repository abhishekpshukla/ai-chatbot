class CreateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :conversations do |t|
      t.string :session_id
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
