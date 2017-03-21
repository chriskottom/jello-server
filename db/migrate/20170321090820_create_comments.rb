class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.references :card, foreign_key: true
      t.references :creator
      t.text :body

      t.timestamps
    end

    add_foreign_key :comments, :users, column: :creator_id
  end
end
