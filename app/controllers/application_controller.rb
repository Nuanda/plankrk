class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_locale


  def render_error(msg, options={})
    error_json = {
      message: msg,
      type: options[:type] || :general
    }
    error_json[:details] = options[:details] if options[:details]

    render(
      json: error_json,
      status: options[:status] || :bad_request
    )
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

end
