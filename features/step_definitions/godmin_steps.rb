Given(/^the following users exist$/) do |table|
  table.hashes.each do |hash|
    user = FactoryGirl.create(:user, hash.except('skills'))
    add_skills(user, hash[:skills]) if hash[:skills]
  end
end

def add_skills(user, skills)
  user.skill_list.add(skills, parse: true)
  user.save
end

Given(/^the following tags exists$/) do |table|
  table.hashes.each do |hash|
    ActsAsTaggableOn::Tag.create(name: hash[name])
  end
end

Given(/^the admin account is set up$/) do
  AdminUser.create!(email: 'admin@admin.com', password: 'password')
end

Given(/^I am logged in as admin$/) do
  visit root_path
  fill_in 'Email', with: 'admin@admin.com'
  fill_in 'Password', with: 'password'
  click_link_or_button 'Sign in'
end

Given(/^I visit the "([^"]*)" page$/) do |url|
  case url
    when 'api-doc'
      visit '/api-doc'
  end
end

Given(/^I click on "([^"]*)"$/) do |link|
  click_link_or_button link
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content text
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_content text
end

And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

And(/^I should see ([^"]*) instances of ([^"]*)$/) do |count, model|
  expect(Object.const_get(model).count).to eq count.to_i
end

And(/^I click on "([^"]*)" for "([^"]*)"$/) do |link, name|
  @resource = User.find_by(user_name: name)
  section = find("tr[data-resource-id=\"#{@resource.id}\"]")
  within section do
    click_link_or_button link
  end
end

And(/^the updated users username is "([^"]*)"$/) do |name|
  @resource.reload
  expect(@resource.user_name).to eq name
end

Then(/^the updated users skills should be "([^"]*)"$/) do |skills|
  @resource ? @resource.reload : @resource = User.last
  skills.split do |skill|
    expect(@resource.skill_list).to include skill
  end
end

Given(/^"([^"]*)" skills are "([^"]*)"$/) do |name, skills|
  user = User.find_by(user_name: name)
  user.skill_list.add(skills, parse: true)
  user.save
end

And(/^I delete the content of "([^"]*)"$/) do |label|
  element = page.find("##{label}", visible: false)
  element.set('')
end

And(/^I set skill tags to "([^"]*)"$/) do |value|
  fill_autocomplete(select: value)
end

def fill_autocomplete(options = {})
  page.execute_script %Q{$('div.selectize-dropdown.multi.form-control div.selectize-dropdown-content div:contains("#{options[:select]}")').trigger('mouseenter').click();}
end

Then(/^I should not see the link "([^"]*)"$/) do |link|
  expect(page).not_to have_link link, exact: true
end

Then(/^I should see "([^"]*)" in the url$/) do |text|
  expect(current_path).to have_content text
end
