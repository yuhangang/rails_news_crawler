class AddIconUrlToPublishers < ActiveRecord::Migration[6.0]
  def change
    add_column :publishers, :icon_url, :string

    slug_to_icon_url = {
      "says" => "https://says.com/favicon.ico",
      "utusan-malaysia" => "https://www.utusan.com.my/favicon.ico",
      "berita-harian" => "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://www.bharian.com.my/&size=512"
    }

    Publisher.find_each do |publisher|
      if slug_to_icon_url[publisher.slug]
        publisher.update(icon_url: slug_to_icon_url[publisher.slug])
      end
    end
  end
end
