Rails.logger.info 'RedmineAzureEasyAuth init.rb start'

# プラグインメタ情報
Redmine::Plugin.register :redmine_azure_easy_auth do
  name        'Redmine Azure EasyAuth'
  author      'Takken Ishibashi'
  description 'Azure App Service EasyAuth によるシングルサインオン'
  version     '0.2.0'
  settings default: {}, partial: 'settings/redmine_azure_easy_auth'
end

RedmineAzureEasyAuth::ApplicationControllerPatch

Rails.logger.info 'RedmineAzureEasyAuth init.rb end'
