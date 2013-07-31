json.array!(@records) do |record|
  json.extract! record, :price
  json.url record_url(record, format: :json)
end
