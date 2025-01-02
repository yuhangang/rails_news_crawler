module Api
  module V1
    class CrawlNewsController < ApplicationController
      protect_from_forgery with: :null_session
      skip_before_action :verify_authenticity_token

      def create
        news_article = NewsArticle.find_by(id: params[:id])

        if news_article.nil? || !news_article.is_a?(NewsArticle)
          return render json: {
            status: "error",
            message: "News article not found"
          }, status: :not_found
        end

        job_id = CrawlArticleJob.new.perform(news_article.publisher_id, news_article.id)

        if job_id
          render json: {
            status: "success",
            message: "News article is being crawled",
            job_id: job_id
          }, status: :ok
        else
          render json: {
            status: "error",
            message: "Failed to enqueue job"
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
