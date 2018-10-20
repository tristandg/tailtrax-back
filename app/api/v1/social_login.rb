module V1

  require_relative('../queries/find-vets.rb')

  require('json')

  class SocialLogin < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults


    resource :social_login do
      content_type :json, 'application/json'
      format :json


      post 'google' do

        token = params[:access_token]

        uri = URI('https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=' + token)

        # Create client
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Create Request
        req = Net::HTTP::Get.new(uri)

        # Fetch Request
        res = http.request(req)

        google_user = JSON.parse(res.body)

        user_email = google_user['email']

        if user_email != nil

          user_to_find = User.find_by_email(user_email)

          if user_to_find == nil

            # We need to flag that this is a new user, but we are not going to create it.
            google_user['new_user'] = true

            google_user

          else

            if user_to_find.authentication_token == '' || user_to_find.authentication_token == nil
              user_to_find.authentication_token = ''
              user_to_find.token_expires = token_expiration_date
              user_to_find.force_authentication_token
              user_to_find.save
            end

            header 'Access-Token', user_to_find.authentication_token
            user_to_find

          end
        else

          puts "This was an invalid token"

        end


      end


      desc 'find a vet with first name'
      params do
        optional :search_string, type: String
      end
      post 'facebook' do

        # Get the facebook login token
        token = params[:access_token]

        puts token
        uri = URI('https://graph.facebook.com/me?access_token=' + token + '&fields=email,first_name,last_name,location,birthday')

        # Create client
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER

        # Create Request
        req = Net::HTTP::Get.new(uri)

        # Fetch Request
        res = http.request(req)

        facebook_user = JSON.parse(res.body)

        user_email = facebook_user['email']

        if user_email != nil

          user_to_find = User.find_by_email(user_email)

          if user_to_find == nil

            # We need to flag that this is a new user, but we are not going to create it.
            facebook_user['new_user'] = true

            facebook_user

          else

            if user_to_find.authentication_token == '' || user_to_find.authentication_token == nil
              user_to_find.authentication_token = ''
              user_to_find.token_expires = token_expiration_date
              user_to_find.force_authentication_token
              user_to_find.save
            end

            header 'Access-Token', user_to_find.authentication_token
            user_to_find

          end
        else

          puts "This was an invalid token"

        end


      end
    end
  end
end
