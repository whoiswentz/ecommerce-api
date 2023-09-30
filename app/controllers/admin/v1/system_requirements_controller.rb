module Admin::V1
  class SystemRequirementsController < ApiController
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

    private

    def system_requirement_params
      params.require(:system_requirement).permit(:name, :os, :storage, :cpu, :memory, :gpu)
    end
  end
end