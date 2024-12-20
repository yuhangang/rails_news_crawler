module Api
  module V1
    class NewsArticlesController < ApplicationController
      def index
        news_articles = NewsArticle.all

         if params[:lang].present?
           news_articles = news_articles.joins(:publisher).where(publishers: { language: params[:lang] })
         end

        render json: {
          status: "success",
          articles: news_articles.map do |article|
            publisher = Publisher.find(article.publisher_id)
            {
              id: article.id,
              title: article.title,
              link: article.link,
              description: article.description,
              content: article.content,
              published_at: article.published_at,
              source: article.source,
              image_url: article.image_url,
              publisher: {
                id: publisher.id,
                name: publisher.name,
                language: publisher.language,
                icon_url: publisher.icon_url
              }
            }
          end
        }, status: :ok
      end
    end
  end
end
