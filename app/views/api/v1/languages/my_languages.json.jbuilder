json.languages @langs do |lang|
  json.id lang.id
  json.language lang.language.name
  json.level lang.level
  json.written lang.written
  json.spoken lang.spoken
  json.created_at lang.created_at
end
