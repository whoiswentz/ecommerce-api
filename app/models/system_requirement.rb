class SystemRequirement < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :os, presence: true
  validates :storage, presence: true
  validates :cpu, presence: true
  validates :gpu, presence: true
  validates :memory, presence: true
end
