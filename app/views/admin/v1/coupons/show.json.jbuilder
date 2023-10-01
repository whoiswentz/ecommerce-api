json.coupon do
  json.(@coupon, :id, :name, :code, :coupon_status, :discount_value, :max_use, :due_date)
end