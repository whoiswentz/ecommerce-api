module Admin::V1
  class ApiController < ApplicationController
    before_action :restrict_access_from_admin!

    class ForbiddenError < StandardError; end

    include Authenticable
    include SimpleErrorRenderable

    self.simple_error_partial = "shared/simple_error"

    rescue_from ForbiddenError do
      render_error(message: "Forbidden access", status: :forbidden)
    end

    private
    def restrict_access_from_admin!
      raise ForbiddenError unless current_user.admin?
    end
  end
end
