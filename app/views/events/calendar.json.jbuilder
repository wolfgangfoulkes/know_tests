json.array!(@events) do |event|
  json.extract! event, :id, :description, :start, :end
  json.title event.name
  json.summary event.name
  json.url event_url(event, format: :html)
end