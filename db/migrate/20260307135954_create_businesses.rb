class CreateBusinesses < ActiveRecord::Migration[8.1]
  def change
    create_table :businesses do |t|
      t.string :name
      t.text :system_prompt

      t.timestamps
    end
  end
end
