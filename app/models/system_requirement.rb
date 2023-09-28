class SystemRequirement < ApplicationRecord
  include Paginatable
  include NameSearchable

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :os, presence: true
  validates :storage, presence: true
  validates :cpu, presence: true
  validates :gpu, presence: true
  validates :memory, presence: true

  has_many :games, dependent: :restrict_with_error
end
