module Admin::V1
  class CategoriesController < ApiController
    before_action :find_category, only: [:update, :destroy]

    def index
      @categories = Category.all
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        render :show
      else
        render_error(fields: @category.errors.messages)
      end
    end

    def update
      if @category.update(category_params)
        render :show
      else
        render_error(fields: @category.errors.messages)
      end
    end

    def destroy
      begin
        @category.destroy
      rescue
        render_error(fields: @category.errors.messages)
      end
    end

    private
    def category_params
      params.require(:category).permit(:name)
    end

    def find_category
      @category = Category.find(params[:id])
    end
  end
end
