class RemoveAuthorFromNewsArticles < ActiveRecord::Migration[8.0]
  def change
    remove_column :news_articles, :author, :string
  end
end
