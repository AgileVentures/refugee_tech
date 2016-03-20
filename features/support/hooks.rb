Before('@api') do
  Capybara.javascript_driver = :rack_test
end