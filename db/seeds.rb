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
  { slug: "says", name: "Says", language: "en", is_new: false, feed_url: "https://says.com/my/rss" },
  { slug: "utusan-malaysia", name: "Utusan Malaysia", language: "ms", is_new: false, feed_url: "https://www.utusan.com.my/feed/" },
  { slug: "beritanasional", name: "Berita Nasional", language: "ms", is_new: false, feed_url: "https://www.bharian.com.my/feed" }
])
