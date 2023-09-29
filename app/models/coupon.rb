class Coupon < ApplicationRecord
  include NameSearchable
  include Paginatable

  enum coupon_status: {
    active: "active",
    inactive: "inactive"
  }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :coupon_status, presence: true, inclusion: { in: coupon_statuses.keys }
  validates :discount_value, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :max_use, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :due_date, presence: true, future_date: true
end
