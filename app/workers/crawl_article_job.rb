class CrawlArticleJob
  include Sidekiq::Job
  include ContentProcessor

  sidekiq_options(
    lock: :until_executed,
    lock_args: ->(args) { [ args.first ] },
    retry: 1,
    dead: false,
    queue: :crawlers
  )

  def perform(news_publisher_id, news_article_id)
    news_article = NewsArticle.find(news_article_id)
    return if news_article.nil? || news_article.link.blank?

    log_info("Starting to crawl content for article", news_article)

    begin
      uri = URI.parse(news_article.link)
      request = Net::HTTP::Get.new(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        article_html = response.body
        article_doc = Nokogiri::HTML(article_html)

        # Get the appropriate content processor based on publisher

        processor = ContentProcessorFactory.create(news_article.publisher.slug)
        content = processor.process(article_doc, news_article.link)

        # Update the NewsArticle
        news_article.update!(
          content: content || news_article.content,
          image_url: article_doc.at_css("meta[property='og:image']")&.[]("content") || news_article.image_url
        )

        log_info("Crawled article successfully", news_article)
      else
        log_error("Failed to fetch article", news_article, error: "HTTP #{response.code}")
      end
    rescue => e
      log_error("Failed to crawl article content", news_article, error: e.message)
    end
  end

  private

  def log_info(message, news_article, extra = {})
    Rails.logger.info(format_log(message, news_article, extra))
  end

  def log_error(message, news_article, extra = {})
    Rails.logger.error(format_log(message, news_article, extra))
  end

  def format_log(message, news_article, extra = {})
    log_data = {
      message: message,
      article: {
        id: news_article.id,
        title: news_article.title,
        link: news_article.link
      },
      extra: extra
    }
    log_data.to_json
  end
end
