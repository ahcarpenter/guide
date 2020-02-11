# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    Rails.logger.error({ error: e.class.to_s, message: e.message, backtrace: e.backtrace }.to_json)

    render_exception_json exception: e
  end

  after_action do |controller|
    response = controller.response

    Rails.logger.info({ response: { body: response.body, status: response.status } }.to_json)
  end

  private

  def render_json(body:, status: :ok)
    render json: { data: body }, status: status
  end

  def render_error_json(error:, status:)
    render_json body: { error: error }, status: status
  end

  def render_exception_json(exception:)
    render_json(
      body: {
        error: exception.class.to_s,
        message: exception.message,
        backtrace: exception.backtrace
      }, status: :internal_server_error
    )
  end
end
