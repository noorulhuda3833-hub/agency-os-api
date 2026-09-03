json.array! @clients do |client|
  json.id client.id
  json.name client.name
  json.email client.email
  json.phone client.phone

  json.company_id client.company_id
  json.company client.company&.name

  json.workspace_id client.workspace_id
  json.created_at client.created_at
  json.updated_at client.updated_at
end