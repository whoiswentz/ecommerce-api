module Admin::V1
  class CategoriesController < ApiController
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

    private
    def category_params
      params.require(:category).permit(:name)
    end
  end
end
