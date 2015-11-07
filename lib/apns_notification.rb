class ApnsNotification
  def initialize(device_token)
    @device_token = device_token
  end

  def intive(game_id)
    return unless @device_token

    create_notification do |notification|
      notification.alert = { "loc-key" => "MSG_INVITE_NOTIFICATION" }
      notification.data = { appdata: { "event" => "invite", "objectId" => game_id } }
    end
  end

  private

  def create_notification
     notification = Rpush::Apns::Notification.new
     notification.app = rpush_app
     notification.device_token = @device_token

     yield notification

     notification.save
  end

  def rpush_app
    @app ||= Rpush::Apns::App.find_by_name(ENV['RPUSH_APP_NAME'])
  end
end
