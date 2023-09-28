require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:profile) }
  it { is_expected.to allow_values(:admin, :normal).for(:profile) }
  it {  is_expected.to define_enum_for(:profile).with_values(admin: "admin", normal: "normal").backed_by_column_of_type(:enum) }

  it_behaves_like "paginatable concern", :user
  it_behaves_like "name searchable concern", :user
end
