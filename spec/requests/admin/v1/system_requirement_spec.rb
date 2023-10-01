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

  context "POST /system_requirements" do
    let!(:url) { "/admin/v1/system_requirements" }

    context "with invalid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

      it_behaves_like "simple post request with invalid params", SystemRequirement
    end

    context "with valid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it_behaves_like "simple post request with valid params", SystemRequirement, 'system_requirement', %i(name os storage cpu memory gpu)
    end
  end

  context "PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "with invalid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

      it "should not update" do
        old_name = system_requirement.name
        patch url, headers: auth_header(user), params: params
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
      end

      it "should return error message" do
        patch url, headers: auth_header(user), params: params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable entity status" do
        patch url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:name) { "New name" }
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: name) }.to_json }

      it "should update" do
        patch url, headers: auth_header(user), params: params
        system_requirement.reload
        expect(system_requirement.name).to eq name
      end

      it "should return updated json" do
        patch url, headers: auth_header(user), params: params
        system_requirement.reload
        expect(json_body['system_requirement']).to eq system_requirement.as_json(only: %i(name os storage cpu memory gpu))
      end

      it "should return http status ok" do
        patch url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "DELETE /system_requirements/:id" do
    let!(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "with valid id" do
      it "should delete" do
        expect {
          delete url, headers: auth_header(user)
        }.to change(SystemRequirement, :count).by(-1)
      end

      it "should not return json body" do
        delete url, headers: auth_header(user)
        expect(json_body).to_not be_present
      end

      it "should return http status no_content" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end