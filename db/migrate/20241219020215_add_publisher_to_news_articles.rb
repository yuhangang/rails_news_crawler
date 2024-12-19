class AddPublisherToNewsArticles < ActiveRecord::Migration[8.0]
  def change
    add_reference :news_articles, :publisher, null: false, foreign_key: true
  end
end
