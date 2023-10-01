require 'rails_helper'

RSpec.describe Admin::V1::CouponsController, type: :request do
  let(:user) { create(:user) }

  context "GET /coupons" do
    let(:url) { "/admin/v1/coupons" }
    let!(:coupons) { create_list(:coupon, 5) }

    it "should return all Coupons" do
      get url, headers: auth_header(user)

      expect(json_body['coupons']).to contain_exactly *coupons.as_json(only: %i(name code coupon_status discount_value max_use due_date))
    end
  end
end