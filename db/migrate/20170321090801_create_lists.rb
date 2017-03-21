class CreateLists < ActiveRecord::Migration[5.0]
  def change
    create_table :lists do |t|
      t.references :board, foreign_key: true
      t.references :creator
      t.string :title
      t.boolean :archived, default: false, null: false

      t.timestamps
    end

    add_foreign_key :lists, :users, column: :creator_id
  end
end
