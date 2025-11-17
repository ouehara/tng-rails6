#===============================================
# CloudFront Basic Authentication Configuration
#
# CloudFront FunctionsでBasic認証を実装
# 開発環境用途で全サイトにBasic認証を追加
# 参考: https://zenn.dev/kuuki/articles/aws-cloudfront-add-basic-auth
#===============================================

#-----------------------------------------------
# Basic認証用のCloudFront Function
#-----------------------------------------------
resource "aws_cloudfront_function" "basic_auth" {
  count   = var.enable_basic_auth ? 1 : 0
  name    = "${local.app_identifier}-${local.environment}-basic-auth"
  runtime = "cloudfront-js-1.0"
  comment = "Basic authentication for development environment"
  publish = true
  code = <<EOF
function handler(event) {
  var request = event.request;
  var headers = request.headers;

  // Base64 encoded credentials (tsunagujapan:tsunagu0904)
  var authString = "Basic dHN1bmFndWphcGFuOnRzdW5hZ3UwOTA0";

  if (
    typeof headers.authorization === "undefined" ||
    headers.authorization.value !== authString
  ) {
    return {
      statusCode: 401,
      statusDescription: "Unauthorized",
      headers: { "www-authenticate": { value: "Basic" } }
    };
  }

  return request;
}
EOF
}