When(/^the Accept Type is (.*)/) do |accept_type|
  @accept_type = accept_type
end


When /^the client requests GET (.*)$/ do |path|
  @last_response = HTTParty.get('http://localhost:9999' + path, :headers => { 'Accept' => @accept_type || 'application/json' })
end

Then(/^a "([^"]*)" status code is returned$/) do |status|
  puts @last_response
  expect(@last_response.response.code).to eq status
end

Then /^the response should be: "(.*)"/ do |text|
  expect(@last_response.body).to eq text
end

Then /^the response should be JSON:$/ do |json|
  expect(JSON.parse(@last_response.body)).to eq JSON.parse(json)
end
