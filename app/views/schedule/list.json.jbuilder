json.array!(@events) do |event|
  json.extract! event, :id, :description
  json.summary event.name
  json.start event.starts_at
  json.end event.ends_at
  json.url event_url(event, format: :html)
  json.is_current_user (event.user == current_user)
end