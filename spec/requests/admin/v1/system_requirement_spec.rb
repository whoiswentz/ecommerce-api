require "rails_helper"

RSpec.describe Admin::V1::SystemRequirementsController, type: :request do
  let(:user) { create(:user) }

  context "GET /system_requirements" do
    let(:url) { "/admin/v1/system_requirements" }
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    before { get url, headers: auth_header(user) }

    it "should return all SystemRequirements" do
      expect(json_body['system_requirements']).to contain_exactly *system_requirements.as_json(only: %i(name os storage cpu memory gpu))
    end

    it "should return http status ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /system_requirements" do
    let!(:url) { "/admin/v1/system_requirements" }

    context "with invalid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

      it "should not create a new SystemRequirement" do
        expect do
          post url, headers: auth_header(user), params: params
        end.not_to change(SystemRequirement, :count)
      end

      it_behaves_like "return error fields", ["name"] do
        before { post url, headers: auth_header(user), params: params }
      end

      include_examples "unprocessable entity http status code" do
        before { post url, headers: auth_header(user), params: params }
      end
    end

    context "with valid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      it "should add a new SystemRequirement" do
        expect do
          post url, headers: auth_header(user), params: params
        end.to change(SystemRequirement, :count).by(1)
      end

      it "should return last added SystemRequirement" do
        post url, headers: auth_header(user), params: params

        expected_model = SystemRequirement.last.as_json(only: %i(name os storage cpu memory gpu))
        expect(json_body["system_requirement"]).to eq expected_model
      end

      it "should return http status ok" do
        post url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "PATCH /system_requirements/:id" do
    let(:system_requirement) { create(:system_requirement) }
    let(:url) { "/admin/v1/system_requirements/#{system_requirement.id}" }

    context "with invalid params" do
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

      before { patch url, headers: auth_header(user), params: params }

      it "should not update" do
        old_name = system_requirement.name
        system_requirement.reload
        expect(system_requirement.name).to eq old_name
      end

      it "should return error message" do

        expect(json_body['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable entity status" do

      expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:name) { "New name" }
      let(:params) { { system_requirement: attributes_for(:system_requirement, name: name) }.to_json }

      before { patch url, headers: auth_header(user), params: params }

      it "should update" do

      system_requirement.reload
        expect(system_requirement.name).to eq name
      end

      it "should return updated json" do
        system_requirement.reload
        expect(json_body['system_requirement']).to eq system_requirement.as_json(only: %i(name os storage cpu memory gpu))
      end

      it "should return http status ok" do
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