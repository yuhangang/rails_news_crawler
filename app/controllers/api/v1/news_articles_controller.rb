module Api
  module V1
    class NewsArticlesController < ApplicationController
      DEFAULT_PAGE = 1
      DEFAULT_PER_PAGE = 20
      MAX_PER_PAGE = 100

      def index
        news_articles = fetch_paginated_articles

        render json: {
          status: "success",
          articles: serialize_articles(news_articles),
          pagination: pagination_metadata(news_articles)
        }, status: :ok
      end

      def show
        article = NewsArticle.includes(:publisher).find_by(id: params[:id])

        if article
          render json: {
            status: "success",
            article: serialize_article(article, include_content: true)
          }, status: :ok
        else
          render_not_found
        end
      end

      private

      def fetch_paginated_articles
        articles = NewsArticle.includes(:publisher).order(published_at: :desc)
        articles = filter_by_language(articles) if params[:lang].present?

        articles.page(page).per(per_page)
      end

      def filter_by_language(scope)
        scope.joins(:publisher).where(publishers: { language: params[:lang] })
      end

      def serialize_articles(articles)
        articles.map { |article| serialize_article(article) }
      end

      def serialize_article(article, include_content: false)
        if include_content
        {
          id: article.id,
          title: article.title,
          link: article.link,
          description: article.description,
          content: article.content,
          published_at: article.published_at,
          source: article.source,
          image_url: article.image_url,
          publisher: serialize_publisher(article.publisher)
        }
        else
        {
          id: article.id,
          title: article.title,
          link: article.link,
          description: article.description,
          published_at: article.published_at,
          source: article.source,
          image_url: article.image_url,
          publisher: serialize_publisher(article.publisher)
        }
        end
      end

      def serialize_publisher(publisher)
        {
          id: publisher.id,
          name: publisher.name,
          language: publisher.language,
          icon_url: publisher.icon_url
        }
      end

      def pagination_metadata(paginated_records)
        {
          current_page: paginated_records.current_page,
          next_page: paginated_records.next_page,
          prev_page: paginated_records.prev_page,
          total_pages: paginated_records.total_pages,
          total_count: paginated_records.total_count,
          per_page: per_page
        }
      end

      def page
        [ params.fetch(:page, DEFAULT_PAGE).to_i, 1 ].max
      end

      def per_page
        [ [ params.fetch(:limit, DEFAULT_PER_PAGE).to_i, 1 ].max, MAX_PER_PAGE ].min
      end

      def render_not_found
        render json: {
          status: "error",
          message: "Article not found"
        }, status: :not_found
      end
    end
  end
end
