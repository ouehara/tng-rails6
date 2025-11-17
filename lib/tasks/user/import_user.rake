require 'csv'
namespace :import_user do
  task :create_user => :environment do
    userFile = File.read('lib/tasks/user/tng_users.csv')
    users = CSV.parse(userFile, :headers => true)
    suppress(Exception) do
      users.each do |row|
        
        user = row.to_hash
        next if User.exists?(user['ID'])
        u = User.new
        u.id = user['ID']
        u.username = user['user_login']
        u.encrypted_password = user['user_pass']
        u.email = user['user_email']
        u.skip_confirmation!
        puts u.save(:validate => false)
      end
    end
  end
end