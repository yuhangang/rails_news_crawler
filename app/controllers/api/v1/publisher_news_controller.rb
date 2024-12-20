module Api
  module V1
    class PublisherNewsController < ApplicationController
      # Ensure the response is JSON
      before_action :set_publisher

      def index
        # Your controller logic here...
        render json: {
          status: "success",
          articles: @publisher.news_articles.map do |article|
            {
              id: article.id,
              title: article.title,
              link: article.link,
              description: article.description,
              content: article.content,
              published_at: article.published_at,
              source: article.source,
              image_url: article.image_url
            }
          end
        }, status: :ok
      end

      private

      def set_publisher
        @publisher = Publisher.find_by(slug: params[:slug])
        if @publisher.nil?
          render json: { status: "error", message: "Publisher not found" }, status: :not_found
        end
      end
    end
  end
end
