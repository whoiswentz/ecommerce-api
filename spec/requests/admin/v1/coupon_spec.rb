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

    it "should return status code ok" do
      get url, headers: auth_header(user)

      expect(response).to have_http_status(:ok)
    end
  end

  context "POST /coupons" do
    let(:url) { "/admin/v1/coupons" }

    context "with invalid params" do
      let(:params) { { coupon: attributes_for(:coupon, code: nil) }.to_json }

      it "should not add new Coupons" do
        expect do
          post url, headers: auth_header(user), params: params
        end.not_to change(Coupon, :count)
      end

      it "should return error message" do
        post url, headers: auth_header(user), params: params
        expect(json_body['errors']['fields']).to have_key('code')
      end

      it "should return unprocessable entity status" do
        post url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:params) { { coupon: attributes_for(:coupon) }.to_json }

      it "should add a new Coupon" do
        expect do
          post url, headers: auth_header(user), params: params
        end.to change(Coupon, :count).by(1)
      end

      it "should return last added Category" do
        post url, headers: auth_header(user), params: params

        expected = Coupon.last.as_json(only: %i(id name code coupon_status discount_value max_use due_date))
        expect(json_body['coupon']).to eq expected
      end

      it "should return http status ok" do
        post url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:created)
      end
    end
  end

  context "PATCH /coupons/:id" do
    let(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context "with invalid params" do
      let(:params) { { coupon: attributes_for(:coupon, name: nil) }.to_json }

      it "should not update" do
        old_name = coupon.name
        patch url, headers: auth_header(user), params: params
        coupon.reload
        expect(coupon.name).to eq old_name
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
      let(:name) { "New Coupon Name" }
      let(:params) { { coupon: attributes_for(:coupon, name: name) }.to_json }

      it "should update" do
        patch url, headers: auth_header(user), params: params
        coupon.reload
        expect(coupon.name).to eq name
      end

      it "should return updated json" do
        patch url, headers: auth_header(user), params: params
        coupon.reload
        expect(json_body['coupon']).to eq coupon.as_json(only: %w(id name code coupon_status discount_value max_use due_date))
      end

      it "should return http status ok" do
        patch url, headers: auth_header(user), params: params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "DELETE /coupons/:id" do
    let!(:coupon) { create(:coupon) }
    let(:url) { "/admin/v1/coupons/#{coupon.id}" }

    context "with valid id" do
      it "should delete" do
        expect {
          delete url, headers: auth_header(user)
        }.to change(Coupon, :count).by(-1)
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