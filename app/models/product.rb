class Product < ApplicationRecord
  validates :name, presence: true
  validates :sku, presence: true, uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  belongs_to :producttable, polymorphic: true

  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
end
