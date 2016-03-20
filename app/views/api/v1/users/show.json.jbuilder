user = @user
json.user do
  json.id user.id
  json.user_name user.user_name
  json.gender user.gender
  json.lat user.latitude
  json.lng user.longitude
  json.city user.city
  json.country user.country
  json.email user.email
  json.skills user.skill_list
  json.created_at user.created_at
end