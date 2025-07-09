# Redmine 5.1.x  ─ 自動 SSO (App Service Easy Auth) 用パッチ

require 'base64'
require 'json'

module RedmineAzureEasyAuth
  module ApplicationControllerPatch
    def try_to_autologin
      user = super
      return user if user
      account = nil
      # Azure Easy Auth（X-MS-CLIENT-PRINCIPAL-NAME ヘッダーを取得）
      principal_header = request.env["HTTP_X_MS_CLIENT_PRINCIPAL"]
      if principal_header
        begin
          decoded = Base64.decode64(principal_header)
          json = JSON.parse(decoded)
          claims = json["claims"] || []
          Rails.logger.info("[redmine_azure_easy_auth] claims: #{claims.inspect}")
          # preferred_username優先、なければemailaddress
          claim = claims.find { |c| c["typ"] == "preferred_username" } ||
                  claims.find { |c| c["typ"] == "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress" }
          Rails.logger.info("[redmine_azure_easy_auth] claim: #{claim.inspect}")
          mail = claim["val"] if claim
          # メールのアカウント部分を account として利用。ただし@がなければそのまま
          account = mail.split('@').first if claim
          claim = claims.find { |c| c["typ"] == "name" } || account
          name = claim["val"] if claim
          # 半角SPC or 全角SPCがある場合はfirstnameとlastnameに分割
            if name
                names = name.split(/[\s　]+/)
                if names.size > 1
                    firstname = names.first
                    lastname = names[1..-1].join(' ')
                else
                    firstname = name
                    lastname = 'User'
                end
            else
                firstname = account
                lastname = 'User'
            end

        rescue => e
          Rails.logger.warn("[redmine_azure_easy_auth] Failed to parse Azure Easy Auth header: #{e}")
          Rails.logger.warn("[redmine_azure_easy_auth] Backtrace:\n#{e.backtrace.join("\n")}")
        end
      end
      return nil unless account

      user = User.active.find_by_login(account)
      unless user
        user = User.new(
          login: account,
          mail:  mail,
          firstname: firstname,
          lastname:  lastname,
          language: 'ja',
          status: User::STATUS_ACTIVE
        )
        user.random_password
        # メールが特定の場合のみ、管理者権限を付与
        # user.admin = (mail == 'hoge@fuga.com')

        # 常に管管理者権限を付与
        user.admin = true

        user.save!
      end

      reset_session
      start_user_session(user)
      user.update_last_login_on!
      user
    end
  end
end

ApplicationController.prepend(RedmineAzureEasyAuth::ApplicationControllerPatch)
