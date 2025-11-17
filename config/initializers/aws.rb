Aws.config.update({
  region: 'ap-northeast-1',
  credentials: Aws::Credentials.new(ENV['TNG_AWS_ACCESS_KEY_ID'], ENV['TNG_AWS_SECRET_ACCESS_KEY']),
})