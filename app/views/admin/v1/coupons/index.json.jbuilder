json.coupons do
  json.array! @coupons, :name, :code, :coupon_status, :discount_value, :max_use, :due_date
end