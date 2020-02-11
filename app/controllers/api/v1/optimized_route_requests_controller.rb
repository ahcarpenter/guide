# frozen_string_literal: true

module Api
  module V1
    class OptimizedRouteRequestsController < ApplicationController
      def index
        @optimized_route_request = OptimizedRouteRequest.find_or_initialize_by(
          hashed_request: Digest::SHA256.hexdigest(serialized_params)
        )

        unless @optimized_route_request.new_record?
          return render json: JSON.parse(@optimized_route_request.response)
        end

        @optimized_route_request.request = serialized_params
        @optimized_route_request.provider_id = params[:provider]

        optimize_route = OptimizeRoute.new
        result = optimize_route.call(optimized_route_request: @optimized_route_request)

        if result.success?
          body = { data: { addresses: result.value! } }
          @optimized_route_request.response = body.to_json
          @optimized_route_request.save

          render_json body: { addresses: result.value! }
        elsif !result.failure[:valid_input]
          render_error_json error: result.failure[:error], status: :unprocessable_entity
        else
          render_error_json error: result.failure[:error], status: :internal_server_error
        end
      end

      private

      def serialized_params
        params.to_json
      end
    end
  end
end
