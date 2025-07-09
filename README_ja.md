# Redmine Azure Easy Auth

RedmineをAzure App ServiceのEasyAuthと連携し、ログイン画面を使わず自動ログイン・ユーザー自動作成を実現するプラグインです。
※Azure App Service（Linux Docker コンテナ）でRedMineをデプロイする必要があります。デプロイ方法はここでは触れません。

## 概要
このプラグインは、Azure EasyAuthのprincipal id（ユーザー情報）を元にRedmineの認証を行い、該当ユーザーが存在しない場合は自動でRedmineユーザーを作成します。Azure App Service上でRedmineを運用する際、ログイン画面を経由せずに自動でログインできます。

- **ログイン画面不要**: Azure EasyAuthのヘッダー情報で自動認証
- **ユーザー自動作成**: 初回アクセス時にRedmineユーザーを自動生成
- **principal idやユーザー情報を利用**: Azureのclaimsからユーザー情報を取得
- **管理者権限の自動付与**: （現状、全ユーザーに管理者権限が付与されます。必要に応じて修正してください）

## 動作確認バージョン
- Redmine 5.1
- Azure App Service（EasyAuth有効）

## インストール方法
1. 本プラグインをRedmineの`plugins`ディレクトリに配置します。
   ```
   git clone <このリポジトリのURL> plugins/redmine_azure_easy_auth
   ```
2. Redmineを再起動します。
3. AzureポータルでApp ServiceのEasyAuth（認証/認可）を有効化してください。

## 使い方
- Azure App Service経由でRedmineにアクセスすると、EasyAuthのヘッダー情報を元に自動でログインします。
- ユーザーが未登録の場合、自動でRedmineユーザーが作成されます。
- ログイン画面は表示されません。

## 注意事項
- デフォルトでは新規ユーザーに管理者権限が付与されます。`lib/redmine_azure_easy_auth/application_controller_patch.rb`内の該当箇所を必要に応じて修正してください。
- ログのダウンロードはプラグイン設定画面から可能です。

## ライセンス
LICENSEファイルを参照してください。
