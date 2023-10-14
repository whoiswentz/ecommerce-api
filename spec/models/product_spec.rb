require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  it { is_expected.to belong_to :productable }
  it { is_expected.to have_many(:product_categories).dependent(:destroy) }
  it { is_expected.to have_many(:categories).through(:product_categories) }
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_presence_of(:product_status) }
  it { is_expected.to allow_values(:out_of_stock, :available).for(:product_status) }
  it { is_expected.to define_enum_for(:product_status)
                        .with_values(available: "available", out_of_stock: "out_of_stock")
                        .backed_by_column_of_type(:enum) }

  it_behaves_like "paginatable concern", :product
  it_behaves_like "name searchable concern", :product

  it { expect(subject.featured).to be_falsey }
end
