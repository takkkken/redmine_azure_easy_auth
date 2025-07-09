# Redmine Azure Easy Auth

A Redmine plugin that enables seamless authentication and automatic user creation using Azure App Service EasyAuth.

Attention: RedMine must be deployed in the Azure App Service (Linux Docker container).Deployment methods are not discussed here.

## Overview
This plugin allows Redmine to authenticate users based on the Azure EasyAuth principal id. When deployed on Azure App Service, Redmine users are automatically logged in without using the standard login screen. If a user does not exist, the plugin will automatically create a Redmine user account based on the Azure principal information.

- **No login screen required**: Users are authenticated via Azure EasyAuth headers.
- **Automatic user creation**: If a user does not exist in Redmine, an account is created on first access.
- **Supports principal id and user claims**: Uses `preferred_username` or email address from Azure claims.
- **Automatic admin assignment**: (Current implementation assigns admin rights to all new users; modify as needed.)

## Requirements
- Redmine 5.1 (Confirmed to work)
- Azure App Service with EasyAuth enabled

## Installation
1. Place this plugin in your Redmine `plugins` directory:
   ```
   git clone <this-repo-url> plugins/redmine_azure_easy_auth
   ```
2. Restart Redmine.
3. Deploy Redmine to Azure App Service and enable EasyAuth (Authentication/Authorization) in the Azure portal.

## Usage
- When a user accesses Redmine via Azure App Service, the plugin reads the EasyAuth headers and logs the user in automatically.
- If the user does not exist, a new Redmine user is created using the Azure principal information.
- No manual login is required.

## Notes
- By default, all new users are granted admin rights. Please review and modify this behavior in `lib/redmine_azure_easy_auth/application_controller_patch.rb` as needed for your environment.
- For troubleshooting, logs can be downloaded from the plugin settings page.

## License
See LICENSE file for details.

