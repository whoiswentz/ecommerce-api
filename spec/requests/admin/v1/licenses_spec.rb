require 'rails_helper'

RSpec.describe Admin::V1::LicensesController, type: :request do
  let(:user) { create(:user) }

  context "GET /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:licenses) {
      licenses_list = []
      15.times { |i| licenses_list << create(:license, key: "#{i}qwe-reew") }
      licenses_list
    }

    before { get url, headers: auth_header(user) }

    it "should return all Licenses" do
      expect(json_body['licenses']).to contain_exactly *licenses.as_json(only: %i(id key license_platform license_status))
    end

    include_examples "ok http status code"
  end

  context "POST /licenses" do
    let(:url) { "/admin/v1/licenses" }
    let!(:game) { create(:game) }

    context "with valid params" do
      let(:params) { { license: { game_id: game.id, license_platform: "steam" } }.to_json }

      before { post url, headers: auth_header(user), params: params }

      it "should return a new license with key nil and status pending_creation" do
        license = License.last
        expect(json_body["license"]).to eq license.as_json(only: %i(id key license_platform license_status))
      end

      include_examples "created http status code"
    end

    context "with invalid params" do
      let(:params) { { license: { license_platform: "steam" } }.to_json }

      before { post url, headers: auth_header(user), params: params }

      include_examples "return error message", ['game']
      include_examples "unprocessable entity http status code"
    end
  end
end