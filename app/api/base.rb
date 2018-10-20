class BASE < Grape::API
  prefix 'api'

  rescue_from :all, :backtrace => false
  format :json
  content_type :json, 'application/json'

  after do
    if @user != nil && @user.authentication_token != nil
      header 'Access-Token', @user.authentication_token
    end
  end

  helpers do
    def warden
      env['warden']
    end

    def authenticated

      # logger.debug "*** BEGIN RAW REQUEST HEADERS ***"
      # request.headers.each do |header|
      #   logger.debug "HEADER KEY: #{header[0]}"
      #   logger.debug "HEADER VAL: #{header[1]}"
      # end
      # logger.debug "*** END RAW REQUEST HEADERS ***"


      #check on token / create expirations
      @non_authenticated_user = User.find_by_authentication_token(request.headers['Access-Token'])
      if @non_authenticated_user != nil
        if @non_authenticated_user.token_expires == nil
          logger.debug "AUTH: FALSE OUT OF RANGE"
          return false
        end

        if DateTime.now > @non_authenticated_user.token_expires
          logger.debug "AUTH: FALSE OUT OF RANGE"
          return false
        else
          #date is within range, if within 15 minutes issue a new token
          #if time_diff(@non_authenticated_user.token_expires, DateTime.now).to_i < 15
          #  #issue a new token && authenticate
          #  @non_authenticated_user.authentication_token = ''
          #  @non_authenticated_user.token_expires = DateTime.now + 48.hours
          #  @non_authenticated_user.force_authentication_token
          #  @non_authenticated_user.save

          #  return true if warden.authenticated?
          #  request.headers['Access-Token'] && @user = User.find_by_authentication_token(@non_authenticated_user.authentication_token)
          #else

          #autenticate
          return true if warden.authenticated?
          request.headers['Access-Token'] && @user = User.find_by_authentication_token(request.headers['Access-Token'])
          #end
        end
      else

        #authenticate
        return true if warden.authenticated?
        request.headers['Access-Token'] && @user = User.find_by_authentication_token(request.headers['Access-Token'])
      end
    end

    def time_diff(start_time, end_time)
      seconds_diff = (start_time - end_time).to_i.abs

      hours = seconds_diff / 3600
      seconds_diff -= hours * 3600

      minutes = seconds_diff / 60
      return minutes

      #seconds_diff -= minutes * 60

      #seconds = seconds_diff

      #"#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
    end


    def current_user
      warden.user || @user
    end
  end

  mount V1::APIBASE

end