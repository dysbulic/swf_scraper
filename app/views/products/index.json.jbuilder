json.array!(@products) do |product|
  json.extract! product, :asin
  json.url product_url(product, format: :json)
end
