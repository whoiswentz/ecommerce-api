module Admin::V1
  class HomeController < ApiController
    def index
      render json: {message: 'ajskdajsdkajsk'}
    end
  end
end