aws_region = "ap-northeast-1" # AWS のリージョン
app_identifier = "w-rails-1026" #アプリケーション識別子
owner_tag = "wizstg"

#-----------------------------------------------
# GitHub の OIDC 認証用設定
# GitHub のユーザー名 または Organization 名
# - 個人リポジトリの場合: `your-github-username`
# - 組織リポジトリの場合: `your-github-org`
#-----------------------------------------------
github_owner = "wizgeek-jp"
github_repo  = "tng-rails6"
oidc_finger_print = "6938fd4d98bab03faadb97b34396831e3780aea1" #SHA-1 thumbprint