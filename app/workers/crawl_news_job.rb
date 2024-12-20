require "rss"
require "open-uri"

class CrawlNewsJob
  include Sidekiq::Job

  def perform
    publishers = Publisher.all
    log_info("Starting to crawl feeds for all publishers", { total_publishers: publishers.count })

    publishers.each do |publisher|
      if publisher.feed_url.blank?
        log_info("Publisher feed URL is blank", publisher)
        next
      end

      log_info("Starting to crawl feed", publisher)

      begin
        # Open the feed URL
        rss_content = URI.open(publisher.feed_url).read
        rss = RSS::Parser.parse(rss_content, false)

        articles_created = 0
        rss.items.each do |item|
          # log all fields of the item

          log_debug("Processing item", publisher, item: item)

          if NewsArticle.exists?(link: item.link)
            log_debug("Article already exists", publisher, link: item.link)
            next
          end

          # Create a new NewsArticle
          NewsArticle.create!(
            title: item.title,
            link: item.link,
            description: item.description || "",
            published_at: item.pubDate || Time.now,
            publisher_id: publisher.id
          ).tap do |news_article|
            articles_created += 1
            log_info("Article created successfully", publisher, link: news_article.link)
            # CrawlArticleJob.perform_async(publisher.id, news_article.id)
          end
        end

        log_info("Crawling completed", publisher, articles_created: articles_created)
      rescue OpenURI::HTTPError => e
        log_error("Failed to fetch feed", publisher, error: e.message)
      rescue RSS::InvalidRSSError => e
        log_error("Invalid RSS feed", publisher, error: e.message)
      rescue StandardError => e
        log_error("Unexpected error occurred", publisher, error: e.message)
      end
    end

    log_info("Finished crawling all publishers")
  end
end


private

  # Helper method for info logs
  def log_info(message, publisher = nil, extra = {})
    Rails.logger.info(format_log(message, publisher, extra))
  end

  # Helper method for error logs
  def log_error(message, publisher = nil, extra = {})
    Rails.logger.error(format_log(message, publisher, extra))
  end

  # Helper method for debug logs
  def log_debug(message, publisher = nil, extra = {})
    Rails.logger.debug(format_log(message, publisher, extra))
  end

# Common log format
def format_log(message, publisher = nil, extra = {})
  log_data = { message: message }

  if publisher.is_a?(Publisher) # Ensure it's a Publisher object
    log_data[:publisher] = {
      id: publisher.id,
      name: publisher.name,
      feed_url: publisher.feed_url
    }
  elsif publisher # Handle cases where publisher might be nil or not a Publisher object
    Rails.logger.warn("Unexpected publisher data: #{publisher.inspect}")
  end

  log_data[:extra] = extra unless extra.empty?
  log_data.to_json
end
