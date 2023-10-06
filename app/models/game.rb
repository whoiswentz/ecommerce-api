class Game < ApplicationRecord
  enum mode: { pvp: 'pvp', pve: 'pve', both: 'both' }

  validates :mode, presence: true, inclusion: { in: modes.keys }
  validates :release_date, presence: true
  validates :developer, presence: true
  belongs_to :system_requirement
  has_one :product, as: :productable
end
