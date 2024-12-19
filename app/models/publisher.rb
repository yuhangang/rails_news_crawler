class Publisher < ApplicationRecord
  LANGUAGES = %w[en ms zh].freeze # Supported languages

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :language, presence: true, inclusion: { in: LANGUAGES }
  validates :is_new, inclusion: { in: [ true, false ] }
  validates :feed_url, presence: true, format: URI.regexp(%w[http https])

  # Scopes for convenience
  scope :new_publishers, -> { where(is_new: true) }
  scope :by_language, ->(lang) { where(language: lang) }
end
