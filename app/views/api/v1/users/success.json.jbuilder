user = @resource
json.message 'success'
json.user do
  json.id user.id
  json.user_name user.user_name
  json.email user.email
  json.mentor user.mentor
  json.lat user.latitude
  json.lng user.longitude
  json.city user.city
  json.country user.country
  json.skills user.skill_list
  json.token user.authentication_token
  json.credentials @credentials if @credentials
end
