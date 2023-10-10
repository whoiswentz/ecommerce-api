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

    it "should return status code ok" do
      expect(response).to have_http_status(:ok)
    end
  end
end