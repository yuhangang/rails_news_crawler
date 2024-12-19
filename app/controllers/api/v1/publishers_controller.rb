module Api
  module V1
    class PublishersController < ApplicationController
      def index
        publishers = Publisher.all

        render json: {
          status: "success",
          data: publishers.map do |publisher|
            {
              id: publisher.id,
              slug: publisher.slug,
              name: publisher.name,
              language: publisher.language,
              is_new: publisher.is_new,
              feed_url: publisher.feed_url
            }
          end
        }, status: :ok
      end
    end
  end
end
