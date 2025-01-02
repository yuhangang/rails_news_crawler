module Api
  module V1
    class PublisherNewsController < ApplicationController
      DEFAULT_PAGE = 1
      DEFAULT_PER_PAGE = 20
      MAX_PER_PAGE = 100

      before_action :set_publisher

      def index
        articles = fetch_paginated_articles

        render json: {
          status: "success",
          publisher: serialize_publisher,
          articles: serialize_articles(articles),
          pagination: pagination_metadata(articles)
        }, status: :ok
      end

      private

      def fetch_paginated_articles
        @publisher
          .news_articles
          .order(published_at: :desc)
          .page(page)
          .per(per_page)
      end

      def serialize_publisher
        {
          id: @publisher.id,
          name: @publisher.name,
          slug: @publisher.slug,
          language: @publisher.language,
          icon_url: @publisher.icon_url
        }
      end

      def serialize_articles(articles)
        articles.map do |article|
          {
            id: article.id,
            title: article.title,
            link: article.link,
            description: article.description,
            published_at: article.published_at,
            source: article.source,
            image_url: article.image_url
          }
        end
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

      def set_publisher
        @publisher = Publisher.find_by(slug: params[:slug])

        if @publisher.nil?
          render json: {
            status: "error",
            message: "Publisher not found",
            details: "No publisher found with slug: #{params[:slug]}"
          }, status: :not_found
        end
      end
    end
  end
end
