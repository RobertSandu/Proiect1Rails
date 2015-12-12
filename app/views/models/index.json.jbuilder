json.array!(@models) do |model|
  json.extract! model, :id, :tweet, :title, :content, :user_id
  json.url model_url(model, format: :json)
end
