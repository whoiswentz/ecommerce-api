module Admin::V1
  class ProductsController < ApiController
    before_action :load_product, only: [:update, :show, :destroy]

    def index
      @loading_service = Admin::ModelLoadingService.new(Product.all, searchable_params)
      @loading_service.call
    end

    def create
      begin
        run_service
        render :show
      rescue Admin::ProductSavingService::NotSavedProductError
        render_error(fields: @saving_service.errors)
      end
    end

    def update
      begin
        run_service
        render :show
      rescue Admin::ProductSavingService::NotSavedProductError
        render_error(fields: @saving_service.errors)
      end
    end

    def show; end

    def destroy
      begin
        @product.productable.destroy!
        @product.destroy!
      rescue ActiveRecord::RecordNotDestroyed
        render_error(fields: @product.errors.messages.merge(@product.productable.errors.messages))
      end
    end

    private

    def searchable_params
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def load_product
      @product = Product.find(params[:id])
    end

    def product_params
      permitted = params.require(:product)
                        .permit(:id, :name, :description, :image, :price, :productable, :product_status, :featured, category_ids: [])
      permitted.merge(productable_params)
    end

    def productable_params
      productable_type = params[:product][:productable] || @product&.productable_type&.underscore
      return unless productable_type.present?
      productable_attributes = send("#{productable_type}_params")
      { productable_attributes: productable_attributes }
    end

    def game_params
      params.require(:product).permit(:mode, :release_date, :developer, :system_requirement_id)
    end

    def run_service(product = nil)
      @saving_service = Admin::ProductSavingService.new(product_params.to_h, @product)
      @saving_service.call
      @product = @saving_service.product
    end
  end
end
