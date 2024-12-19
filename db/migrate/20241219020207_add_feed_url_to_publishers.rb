class AddFeedUrlToPublishers < ActiveRecord::Migration[8.0]
  def change
    add_column :publishers, :feed_url, :string
  end
end
