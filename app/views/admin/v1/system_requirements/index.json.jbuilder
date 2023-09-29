json.system_requirements do
  json.array! @system_requirements, :name, :os, :storage, :cpu, :memory, :gpu
end