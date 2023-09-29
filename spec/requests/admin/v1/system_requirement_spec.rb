require "rails_helper"

RSpec.describe Admin::V1::SystemRequirementsController, type: :request do
  let(:user) { create(:user) }

  context "GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    it "should return all SystemRequirements" do
      get url, headers: auth_header(user)

      expect(json_body['system_requirements']).to contain_exactly *system_requirements.as_json(only: %i(name os storage cpu memory gpu))
    end

    it "should return http status ok" do
      get url, headers: auth_header(user)

      expect(response).to have_http_status(:ok)
    end
  end
end