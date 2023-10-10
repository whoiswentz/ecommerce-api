module Admin::V1
  class LicensesController < ApiController
    def index
      @licenses = License.all
    end

    def create
      @license = License.new(license_params)
      if @license.save
        render :show, status: :created
      else
        render_error(fields: @license.errors.messages)
      end
    end

    def show
      begin
        @license = License.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        raise NotFoundError
      end
    end

    private

    def license_params
      params.require(:license).permit(:game_id, :license_platform)
    end
  end
end