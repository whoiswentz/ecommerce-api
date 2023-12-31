require 'rails_helper'

RSpec.describe Admin::V1::ProductsController, type: :request do
  let(:user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:categories) { create_list(:category, 2) }
    let!(:products) { create_list(:product, 10, categories: categories) }

    context "without any params" do
      it "returns 10 records" do
        get url, headers: auth_header(user)
        expect(json_body['products'].count).to eq 10
      end

      it "returns Products with :productable following default pagination" do
        get url, headers: auth_header(user)
        expected_return = products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(json_body['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user) }
      end
    end

    context "with search[name] param" do
      let!(:search_name_products) do
        products = []
        15.times { |n| products << create(:product, name: "Search #{n + 1}") }
        products
      end

      let(:search_params) { { search: { name: "Search" } } }

      it "returns only seached products limited by default pagination" do
        get url, headers: auth_header(user), params: search_params
        expected_return = search_name_products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(json_body['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: search_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 15, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: search_params }
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(user), params: pagination_params
        expect(json_body['products'].count).to eq length
      end

      it "returns products limited by pagination" do
        get url, headers: auth_header(user), params: pagination_params
        expected_return = products[5..9].map do |product|
          build_game_product_json(product)
        end
        expect(json_body['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 2, length: 5, total: 10, total_pages: 2 } do
        before { get url, headers: auth_header(user), params: pagination_params }
      end
    end

    context "with order params" do
      let(:order_params) { { order: { name: 'desc' } } }

      it "returns ordered products limited by default pagination" do
        get url, headers: auth_header(user), params: order_params
        products.sort! { |a, b| b[:name] <=> a[:name] }
        expected_return = products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(json_body['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end

      it_behaves_like 'pagination meta attributes', { page: 1, length: 10, total: 10, total_pages: 1 } do
        before { get url, headers: auth_header(user), params: order_params }
      end
    end
  end

  context "POST /products" do
    let(:url) { "/admin/v1/products" }
    let(:categories) { create_list(:category, 2) }
    let(:system_requirement) { create(:system_requirement) }
    let(:post_header) { auth_header(user, merge_with: { 'Content-Type' => 'multipart/form-data' }) }

    context "with valid params" do
      let(:game_params) { attributes_for(:game, system_requirement_id: system_requirement.id) }
      let(:product_params) do
        { product: attributes_for(:product).merge(category_ids: categories.map(&:id))
                                           .merge(productable: "game")
                                           .merge(game_params) }
      end

      it 'adds a new Product' do
        expect do
          post url, headers: post_header, params: product_params
        end.to change(Product, :count).by(1)
      end

      it 'adds a new productable' do
        expect do
          post url, headers: post_header, params: product_params
        end.to change(Game, :count).by(1)
      end

      it 'associates categories to Product' do
        post url, headers: post_header, params: product_params
        expect(Product.last.categories.ids).to contain_exactly *categories.map(&:id)
      end

      it 'returns last added Product' do
        post url, headers: post_header, params: product_params
        expected_product = build_game_product_json(Product.last)
        expect(json_body['product']).to eq expected_product
      end

      it 'returns success status' do
        post url, headers: post_header, params: product_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid Product params" do
      let(:game_params) { attributes_for(:game, system_requirement_id: system_requirement.id) }
      let(:product_invalid_params) do
        { product: attributes_for(:product, name: nil).merge(category_ids: categories.map(&:id))
                                                      .merge(productable: "game").merge(game_params) }
      end

      it 'does not add a new Product' do
        expect do
          post url, headers: post_header, params: product_invalid_params
        end.to_not change(Product, :count)
      end

      it 'does not add a new productable' do
        expect do
          post url, headers: post_header, params: product_invalid_params
        end.to_not change(Game, :count)
      end

      it 'does not create ProductCategory' do
        expect do
          post url, headers: post_header, params: product_invalid_params
        end.to_not change(ProductCategory, :count)
      end

      it 'returns error message' do
        post url, headers: post_header, params: product_invalid_params
        expect(json_body['errors']['fields']).to have_key('name')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: post_header, params: product_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with invalid :productable params" do
      let(:game_params) { attributes_for(:game, developer: "", system_requirement_id: system_requirement.id) }
      let(:invalid_productable_params) do
        { product: attributes_for(:product).merge(productable: "game").merge(game_params) }
      end

      it 'does not add a new Product' do
        expect do
          post url, headers: post_header, params: invalid_productable_params
        end.to_not change(Product, :count)
      end

      it 'does not add a new productable' do
        expect do
          post url, headers: post_header, params: invalid_productable_params
        end.to_not change(Game, :count)
      end

      it 'does not create ProductCategory' do
        expect do
          post url, headers: post_header, params: invalid_productable_params
        end.to_not change(ProductCategory, :count)
      end

      it 'returns error message' do
        post url, headers: post_header, params: invalid_productable_params
        expect(json_body['errors']['fields']).to have_key('developer')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: post_header, params: invalid_productable_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "without :productable params" do
      let(:product_without_productable_params) do
        { product: attributes_for(:product).merge(category_ids: categories.map(&:id)) }
      end

      it 'does not add a new Product' do
        expect do
          post url, headers: post_header, params: product_without_productable_params
        end.to_not change(Product, :count)
      end

      it 'does not add a new productable' do
        expect do
          post url, headers: post_header, params: product_without_productable_params
        end.to_not change(Game, :count)
      end

      it 'does not create ProductCategory' do
        expect do
          post url, headers: post_header, params: product_without_productable_params
        end.to_not change(ProductCategory, :count)
      end

      it 'returns error message' do
        post url, headers: post_header, params: product_without_productable_params
        expect(json_body['errors']['fields']).to have_key('productable')
      end

      it 'returns unprocessable_entity status' do
        post url, headers: post_header, params: product_without_productable_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

def build_game_product_json(product)
  json = product.as_json(only: %i(id name description price product_status featured))
  json['image_url'] = rails_blob_url(product.image)
  json['productable'] = product.productable_type.underscore
  json['productable_id'] = product.productable_id
  json['categories'] = product.categories.pluck(:name)
  json.merge! product.productable.as_json(only: %i(mode release_date developer))
  # json['system_requirement'] = product.productable.system_requirement.as_json
  json
end
