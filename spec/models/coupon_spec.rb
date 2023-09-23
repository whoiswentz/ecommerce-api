require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { is_expected.to validate_presence_of(:code) }
  it { is_expected.to validate_uniqueness_of(:code).case_insensitive }
  it { is_expected.to validate_presence_of(:coupon_status) }
  it { is_expected.to allow_values(:active, :inactive).for(:coupon_status) }
  it { is_expected.to define_enum_for(:coupon_status)
                        .with_values(active: "active", inactive: "inactive")
                        .backed_by_column_of_type(:enum) }
  it { is_expected.to validate_presence_of(:discount_value) }
  it { is_expected.to validate_numericality_of(:discount_value).only_integer.is_greater_than(0) }
  it { is_expected.to validate_numericality_of(:max_use).only_integer.is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_presence_of(:due_date) }
end
