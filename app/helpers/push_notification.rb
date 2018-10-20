class PushNotification


  def initialize(user, message)


    @user = user
    @message = message

  end

  def send_notification

    if @user.push_token_type == "android"

      push_app = Rpush::Apns::App.find_by_name("android_tt_app")

      # if push_app == nil
      #   create_android_configuration
      # end


      unless @user.push_token.nil?

        create_android_notification

        send_rpush

      end

    else

      if @user.push_token_type == "ios"

        push_app = Rpush::Apns::App.find_by_name("ios_tt_app")

        create_ios_configuration if push_app == nil

        unless @user.push_token.nil?

          create_ios_notification

          send_rpush
        end

      end
    end

  end

  private

  def send_rpush
    Thread.new do
      Rpush.push
    end
  end

  def create_android_notification
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name("android_tt_app")
    n.registration_ids = [@user.push_token]
    n.data = {message: @message}
    n.priority = 'high' # Optional, can be either 'normal' or 'high'
    # Optional notification payload. See the reference below for more keys you can use!
    n.save!

  end

  def create_android_configuration
    app = Rpush::Gcm::App.new
    app.name = "android_tt_app"
    app.auth_key = File.read(Rails.root.join('public/certs/auth.key'))
    app.connections = 1
    app.environment = "development"
    app.save!
  end

  def create_ios_notification
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name("ios_tt_app")
    n.device_token = @user.push_token
    n.alert = @message
    n.save!
  end

  def create_ios_configuration
    cert = File.read(Rails.root.join('public/certs/development.pem'))
    app = Rpush::Apns::App.new
    app.name = "ios_tt_app"
    app.certificate = cert
    app.environment = "development"
    # app.password = "tailtrax"
    app.connections = 1
    app.save!
  end
end