require 'rails_helper'

RSpec.describe License, type: :model do
  subject { create(:license, key: "qwer-reeqw") }

  it { is_expected.to validate_uniqueness_of(:key)
                        .case_insensitive
                        .scoped_to(:license_platform) }

  it { is_expected.to validate_presence_of(:license_platform) }
  it { is_expected.to allow_values(:steam, :battle_net, :origin, :ps5, :xbox).for(:license_platform) }
  it { is_expected.to define_enum_for(:license_platform)
                        .with_values(steam: "steam",
                                     battle_net: "battle_net",
                                     origin: "origin",
                                     ps5: "ps5",
                                     xbox: "xbox")
                        .backed_by_column_of_type(:enum) }

  it { is_expected.to validate_presence_of(:license_status) }
  it { is_expected.to allow_values(:used, :available, :canceled, :pending_creation, :pending_cancellation)
                        .for(:license_status) }
  it { is_expected.to define_enum_for(:license_status)
                        .with_values(used: "used",
                                     available: "available",
                                     canceled: "canceled",
                                     pending_creation: "pending_creation",
                                     pending_cancellation: "pending_cancellation")
                        .backed_by_column_of_type(:enum) }

  it { is_expected.to belong_to :game }
end
