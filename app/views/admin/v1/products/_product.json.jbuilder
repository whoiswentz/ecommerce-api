json.(product, :id, :name, :description, :price, :product_status)
json.image_url rails_blob_url(product.image)
json.productable product.productable_type.underscore
json.productable_id product.productable_id
json.categories product.categories.pluck(:name)
