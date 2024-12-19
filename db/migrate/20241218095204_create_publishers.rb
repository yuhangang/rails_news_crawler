class CreatePublishers < ActiveRecord::Migration[8.0]
  def change
    create_table :publishers do |t|
      t.string :slug
      t.string :name
      t.string :language
      t.boolean :is_new

      t.timestamps
    end

    add_index :publishers, :slug, unique: true
  end
end
