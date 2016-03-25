Apipie.configure do |config|
  config.app_name                = 'Project Unify'
  config.app_info                = 'This describes the resources that make up the official Project Unify public API v1. If you have any problems or requests please contact the AgileVentures-Project Unify development team'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api-doc'
  #config.default_version         = '0'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/**/*.rb"
end
