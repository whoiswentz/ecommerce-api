module Admin::V1
  class SystemRequirementsController < ApiController
    before_action :find_system_requirement, only: [:update, :destroy]

    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirement = SystemRequirement.new(system_requirement_params)
      if @system_requirement.save
        render :show
      else
        render_error(fields: @system_requirement.errors.messages)
      end
    end

    def update
      if @system_requirement.update(system_requirement_params)
        render :show
      else
        render_error(fields: @system_requirement.errors.messages)
      end
    end

    def destroy
      begin
        @system_requirement.destroy
      rescue
        render_error(fields: @system_requirement.errors.messages)
      end
    end

    private

    def system_requirement_params
      params.require(:system_requirement).permit(:name, :os, :storage, :cpu, :memory, :gpu)
    end

    def find_system_requirement
      @system_requirement = SystemRequirement.find(params[:id])
    end
  end
end