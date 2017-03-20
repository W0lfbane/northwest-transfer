json.extract! note, :id, :text, :author, :created_at, :updated_at
json.url note_url(note, format: :json)
