require 'rails_helper'

RSpec.describe Admin::V1::CategoriesController, type: :request do
  let(:user) { create(:user) }

  context "GET /categories" do
    let(:url) { "/admin/v1/categories" }
    let!(:categories) { create_list(:category, 10) }

    context "without any params" do
      it "returns a total of 10 categories" do
        get url, headers: auth_header(user)
        expect(json_body['categories'].count).to eq 10
      end

      it "returns 10 first categories" do
        get url, headers: auth_header(user)
        expected = categories.as_json(only: %i(id name))
        expect(json_body['categories']).to contain_exactly *expected
      end

      it "returns ok http status code" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with search[name] params" do
      let(:search_params) { { search: { name: "Search" } } }
      let!(:search_name_categories) do
        categories = []
        15.times { |n| categories << create(:category, name: "Search#{n + 1}") }
        categories
      end

      it "returns only searched categories limited by default pagination" do
        get url, headers: auth_header(user), params: search_params
        expected = search_name_categories[0..9].map do |category|
          category.as_json(only: %i(id name))
        end
        expect(json_body['categories']).to contain_exactly *expected
      end

      it "returns ok http status code" do
        get url, headers: auth_header(user), params: search_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(json_body['categories'].count).to eq length
      end

      it "returns categories limited by pagination" do
        get url, headers: auth_header(user), params: pagination_params
        expected = categories[5..9].as_json(only: %i(id name))
        expect(json_body['categories']).to contain_exactly *expected
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with order params" do
      let(:order_params) { { order: { name: 'desc' } } }

      it "returns ordered categories limited by default pagination" do
        get url, headers: auth_header(user), params: order_params
        categories.sort! { |a, b| b[:name] <=> a[:name] }
        expected = categories[0..9].as_json(only: %i(id name))
        expect(json_body['categories']).to contain_exactly *expected
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end
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

  context "PATCH /categories/:id" do
    let(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    context "with invalid params" do
      let(:category_params) { { category: attributes_for(:category, name: nil) }.to_json }

      it "should not update" do
        old_name = category.name
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq old_name
      end

      it "should return error message" do
        patch url, headers: auth_header(user), params: category_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it "should return unprocessable entity status" do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with valid params" do
      let(:category_name) { "My New Category Name" }
      let(:category_params) { { category: attributes_for(:category, name: category_name) }.to_json }

      it "should update" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(category.name).to eq category_name
      end

      it "should return updated json" do
        patch url, headers: auth_header(user), params: category_params
        category.reload
        expect(json_body['category']).to eq category.as_json(only: %w(id name))
      end

      it "should return http status ok" do
        patch url, headers: auth_header(user), params: category_params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context "DELETE /categories/:id" do
    let!(:category) { create(:category) }
    let(:url) { "/admin/v1/categories/#{category.id}" }

    context "with valid id" do
      it "should delete" do
        expect {
          delete url, headers: auth_header(user)
        }.to change(Category, :count).by(-1)
      end

      it "should not return json body" do
        delete url, headers: auth_header(user)
        expect(json_body).to_not be_present
      end

      it "should return http status no_content" do
        delete url, headers: auth_header(user)
        expect(response).to have_http_status(:no_content)
      end

      it "should remove all associated product categories" do
        product_categories = create_list(:product_category, 3, category: category)
        delete url, headers: auth_header(user)
        expected_product_categories = ProductCategory.where(id: product_categories.map(&:id))
        expect(expected_product_categories).to eq []
      end
    end
  end
end
