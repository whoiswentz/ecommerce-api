module Admin::V1
  class CouponsController < ApiController
    before_action :find_coupon, only: [:update, :destroy]

    def index
      @coupons = Coupon.all
    end

    def create
      @coupon = Coupon.new(coupon_params)
      if @coupon.save
        render :show, status: :created
      else
        render_error(fields: @coupon.errors.messages)
      end
    end

    def update
      if @coupon.update(coupon_params)
        render :show
      else
        render_error(fields: @coupon.errors.messages)
      end
    end

    def destroy
      begin
        @coupon.destroy
      rescue
        render_error(fields: @coupon.errors.messages)
      end
    end

    private

    def coupon_params
      params
        .require(:coupon)
        .permit(:name, :code, :coupon_status, :discount_value, :max_use, :due_date)
    end

    def find_coupon
      @coupon = Coupon.find(params[:id])
    end
  end
end