json.licenses do
  json.array! @licenses, :id, :key, :license_platform, :license_status
end