module Admin::V1
  class LicensesController < ApiController
    before_action :find_license_by_id, only: [:show, :update, :destroy]
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

    def show; end

    def update
      if @license.update(license_params)
        render :show
      else
        render_error(fields: @license.errors.messages)
      end
    end

    def destroy
      begin
        @license.destroy
      rescue ActiveRecord::RecordNotDestroyed
        render_error(fields: @license.errors.messages)
      end
    end

    private

    def license_params
      params.require(:license).permit(:game_id, :license_platform)
    end

    def find_license_by_id
      begin
        @license = License.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        raise NotFoundError
      end
    end
  end
end