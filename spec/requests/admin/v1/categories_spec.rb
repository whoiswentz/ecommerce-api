require 'rails_helper'

RSpec.describe "Admin::V1::Categories", type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 5) }

    it "return all Categories" do
      get url, headers: auth_header(user)

      expect(response).to have_http_status(:ok)
      expect(json_body['categories']).to contain_exactly *categories.as_json(only: %i(id name))
    end
  end

  context "POST /categories" do
    let(:url) { "/admin/v1/categories" }

    context "with invalid params" do
      let(:category_params) { { category: attributes_for(:category, name: nil) }.to_json }

      it "should not add new Category" do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.not_to change(Category, :count)
      end

      it "should return error message" do
        post url, headers: auth_header(user), params: category_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable entity status" do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      it "should add a new Category" do
        expect do
          post url, headers: auth_header(user), params: category_params
        end.to change(Category, :count).by(1)
      end

      it "should return last added Category" do
        post url, headers: auth_header(user), params: category_params

        expected_category = Category.last.as_json(only: %i(id name))
        expect(json_body['category']).to eq expected_category
      end

      it "should return http status ok" do
        post url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
