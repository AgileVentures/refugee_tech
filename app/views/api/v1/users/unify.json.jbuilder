user = @user
matches = @unified_users

json.user do
  json.id user.id
  json.user_name user.user_name
  json.skills user.skill_list
  json.created_at user.created_at
end
json.matches(matches) do |match|
  json.user do
    json.id match.id
    json.user_name match.user_name
    json.created_at match.created_at
    json.skills match.skill_list
    json.profile api_v1_user_url(match)
  end
end
