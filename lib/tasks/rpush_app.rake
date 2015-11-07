namespace :rpush_app do
  desc 'Create rpush application'
  task create: :environment do |task|
    app = Rpush::Apns::App.new
    app.name = ENV['RPUSH_APP_NAME']
    app.certificate = ENV['RPUSH_CERTIFICATE']
    app.environment = "production"
    app.password = ENV['RPUSH_CERTIFICATE_PAASSWORD']
    app.connections = 1
    app.save!
  end
end

