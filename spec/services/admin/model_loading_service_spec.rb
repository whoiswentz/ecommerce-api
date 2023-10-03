require 'rails_helper'

RSpec.describe Admin::ModelLoadingService, type: :service do
  context "when call" do
    let!(:categories) { create_list(:category, 15) }

    context "when params are preset" do
      let!(:search_categories) do
        categories = []
        15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
        categories
      end

      let(:params) do
        { search: { name: "Search" }, order: { name: :desc }, page: 2, length: 4 }
      end

      it "return right :length following pagination" do
        service = described_class.new(Category.all, params)
        result = service.call
        expect(result.count).to eq 4
      end

      it "return records following search, order and pagination" do
        search_categories.sort! { |a, b| b[:name] <=> a[:name] }
        service = described_class.new(Category.all, params)
        result = service.call
        expected = search_categories[4..7]
        expect(result).to contain_exactly *expected
      end
    end

    context "when params are not present" do
      it "returns default :length pagination" do
        service = described_class.new(Category.all, nil)
        result = service.call
        expect(result.count).to eq 10
      end

      it "returns first 10 records" do
        service = described_class.new(Category.all, nil)
        result = service.call
        expected = categories[0..9]
        expect(result).to contain_exactly *expected
      end
    end
  end
end