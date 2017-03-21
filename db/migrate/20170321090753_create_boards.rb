class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards do |t|
      t.references :creator
      t.string :title
      t.boolean :archived, default: false, null: false

      t.timestamps
    end

    add_foreign_key :boards, :users, column: :creator_id
  end
end
