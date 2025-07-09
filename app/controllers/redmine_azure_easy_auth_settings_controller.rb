class RedmineAzureEasyAuthSettingsController < ApplicationController
    unloadable
  
    before_action :require_admin
  
    def download_log
      log_path = Rails.root.join('log', "#{Rails.env}.log")
      if File.exist?(log_path)
        send_file log_path, filename: "#{Rails.env}.log", type: 'text/plain'
      else
        render plain: "ログファイルが見つかりません: #{log_path}", status: 404
      end
    end
  end