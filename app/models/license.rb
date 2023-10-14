class License < ApplicationRecord
  enum license_platform: {
    steam: "steam",
    battle_net: "battle_net",
    origin: "origin",
    ps5: "ps5",
    xbox: "xbox"
  }

  enum license_status: {
    used: "used",
    available: "available",
    canceled: "canceled",
    pending_creation: "pending_creation",
    pending_cancellation: "pending_cancellation"
  }

  validates :key, uniqueness: { case_sensitive: false, scope: :license_platform }, allow_nil: true
  validates :license_platform, presence: true, inclusion: { in: license_platforms.keys }
  validates :license_status, presence: true, inclusion: { in: license_statuses.keys }

  belongs_to :game
end
