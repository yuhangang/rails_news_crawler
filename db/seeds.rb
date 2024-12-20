# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Publisher.create!([
  { slug: "says", name: "Says", language: "en", is_new: false, feed_url: "https://says.com/my/rss", icon_url: "https://says.com/favicon.ico" },
  { slug: "utusan-malaysia", name: "Utusan Malaysia", language: "ms", is_new: false, feed_url: "https://www.utusan.com.my/feed/", icon_url: "https://www.utusan.com.my/favicon.ico" },
  { slug: "beritan-harian", name: "Berita Harian", language: "ms", is_new: false, feed_url: "https://www.bharian.com.my/feed", icon_url: "https://t1.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=https://www.bharian.com.my/&size=512" }
])
