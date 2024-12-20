class NewsArticle < ApplicationRecord
  belongs_to :publisher
  validates :title, presence: true
  validates :link, presence: true, uniqueness: true # Prevent duplicates
  validates :published_at, presence: true

  scope :recent, -> { order(published_at: :desc) }
  scope :from_source, ->(source) { where(source: source) }
end
