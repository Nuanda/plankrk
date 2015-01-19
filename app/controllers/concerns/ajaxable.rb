module Ajaxable
  extend ActiveSupport::Concern

  included do
    rescue_from CanCan::AccessDenied do |exception|
      render_error(exception.message, status: current_user ? 403 : 401)
    end
  end
end
