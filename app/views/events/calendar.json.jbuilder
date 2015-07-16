json.array!(@events) do |event|
  json.extract! event, :id, :description
  json.title event.name
  json.summary event.name
  json.start event.starts_at
  json.end event.ends_at
  json.url event_url(event, format: :html)
end