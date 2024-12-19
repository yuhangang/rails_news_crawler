class CreateNewsArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :news_articles do |t|
      t.string :title
      t.string :link
      t.text :description
      t.text :content
      t.datetime :published_at
      t.string :author
      t.string :source
      t.string :image_url

      t.timestamps
    end

    add_index :news_articles, :link, unique: true
    add_index :news_articles, :published_at
    add_index :news_articles, :source
  end
end
