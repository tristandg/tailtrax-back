module V1
  class Users < Grape::API
    prefix 'api'

    require 'grape'
    require 'mini_magick'

    include Defaults

    def self.token_expiration_date
      DateTime.now + 8760.hours
    end

    resource :users do
      content_type :json, 'application/json'
      format :json

      post '/signin', root: :user do
        @user = nil
        if @user = User.find_by_email(params[:username])
          if @user.valid_password?(params[:password])
            if @user.authentication_token == '' || @user.authentication_token == nil
              @user.authentication_token = ''
              @user.token_expires = token_expiration_date
              @user.force_authentication_token
              @user.save
            end

            header 'Access-Token', @user.authentication_token
            @user
          else
            error!('401 Unauthorized', 401)
          end
        elsif @user = User.find_by_username(params[:username])
          if @user.valid_password?(params[:password])
            if @user.authentication_token == '' || @user.authentication_token == nil
              @user.authentication_token = ''
              @user.token_expires = token_expiration_date
              @user.force_authentication_token
              @user.save
            end

            header 'Access-Token', @user.authentication_token
            @user
          else
            error!('401 Unauthorized', 401)
          end
        else
          error!('401 Unauthorized', 401)
        end
      end

      params do
        requires :email
        requires :password
      end
      post '/create_user', root: :user do

        @userToCreate = User.create!({:email => params[:email],
                                      :password => params[:password],
                                      :password_confirmation => params[:password],
                                      :first_name => params[:first_name],
                                      :last_name => params[:last_name],
                                      :phone => params[:phone],
                                      :location => params[:location],
                                      :role => params[:role],
                                      :website => params[:website],
                                      :business_name => params[:business_name]
                                     })
        @userToCreate.token_expires = token_expiration_date
        @userToCreate.save

        @userToCreate.ensure_authentication_token

        @userToCreate
      end

      params do
        requires :username
        requires :password
      end
      post '/signup', root: :user do

        @user = User.create!({:email => params[:email],
                              :username => params[:username],
                              :password => params[:password],
                              :password_confirmation => params[:password],
                              :first_name => params[:first_name],
                              :last_name => params[:last_name],
                              :phone => params[:phone],
                              :location => params[:location],
                              :role => params[:role],
                              :website => params[:website],
                              :address => params[:address],
                              :city => params[:city],
                              :state => params[:state],
                              :zip => params[:zip],
                              :is_minor => params[:is_minor],
                              :parent_email => params[:parent_email]
                             })
        @user.token_expires = DateTime.now + 8760.hours
        @user.save

        @user.ensure_authentication_token

        header 'Access-Token', @user.authentication_token

        @user
      end

      put '/update/:id', root: :user do
        @userToUpdate = User.find(params[:id])

        if params.has_key?(:first_name)
          @userToUpdate.first_name = params[:first_name]
        end

        if params.has_key?(:last_name)
          @userToUpdate.last_name = params[:last_name]
        end

        if params.has_key?(:location)
          @userToUpdate.location = params[:location]
        end
        if params.has_key?(:phone)
          @userToUpdate.phone = params[:phone]
        end

        if params.has_key?(:role)
          @userToUpdate.role = params[:role]
        end
        if params.has_key?(:website)
          @userToUpdate.website = params[:website]
        end
        if params.has_key?(:parent_email)
          @userToUpdate.parent_email = params[:parent_email]
        end
        if params.has_key?(:address)
          @userToUpdate.address = params[:address]
        end
        if params.has_key?(:city)
          @userToUpdate.city = params[:city]
        end
        if params.has_key?(:state)
          @userToUpdate.state = params[:state]
        end
        if params.has_key?(:zip)
          @userToUpdate.zip = params[:zip]
        end
        if params.has_key?(:profile_image)
          @userToUpdate.profile_image = params[:profile_image]
        end
        if params.has_key?(:background_image)
          @userToUpdate.background_image = params[:background_image]
        end
        if params.has_key?(:is_minor)
          @userToUpdate.is_minor = params[:is_minor]
        end
        if params.has_key?(:parent_email)
          @userToUpdate.parent_email = params[:parent_email]
        end
        if params.has_key?(:bio)
          @userToUpdate.bio = params[:bio]
        end

        @userToUpdate.save

        @userToUpdate
      end

      delete '/delete/:id', root: :user do
        @userToDelete = User.find(params[:id])

        @userToDelete.delete

        @userToDelete
      end

      get '/', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @user
      end

      post '/checkuser', root: :user do
        if @userToFind = User.find_by_email(params[:username])
          true
        else
          false
        end
      end

      post '/changePassword', root: :user do

        error!('401 Unauthorized', 401) unless authenticated

        if @user.valid_password?(params[:old_password])
          @user.password = @user.password_confirmation = params[:new_password]
          @user.save
          return true

        else
          return false
        end
      end


      post '/get_users_name', root: :user do

        if @userToFind = User.find_by(email: params[:email])
          @userToFind.first_name
        elsif @userToFind = User.find_by(username: params[:email])
          @userToFind.first_name
        else
          ""
        end
      end

      post '/update_token', root: :user do
        error!('401 Unauthorized', 401) unless authenticated

        @user.push_token = params[:push_token]
        @user.push_token_type = params[:push_token_type]

        @user.save

        @user
      end

      post '/search', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @users = User.where("(username like ? or first_name like ? or last_name like ?) and id != ?", "%" + params[:search], "%" + params[:search], "%" + params[:search], @user.id)
        @users
      end


      get '/all', root: :user do
        error!('401 Unauthorized', 401) unless authenticated

        #if @user.admin?
        @users = User.all
        #elsif
        #  @users = @user
        #end

        @users

      end

      post '/invalidate_token', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @user.token_expires = nil
        @user.save
        @user
      end

      # returns people that @user.id follows
      # TODO: think that it includes followed and follower of user id?
      get '/follows', root: :user do
        error!('401 Unauthorized', 401) unless authenticated

        return Follow.includes(:followed, :follower).
            where(user_id: @user.id).
            where(follow_type: Follow.follow_types[:user_follow])
      end

      params do
        requires :role, type: String
      end
      get '/users-followed-by-role-type', root: :user do
        error!('401 Unauthorized', 401) unless authenticated

        return Follow.includes(:followed, :follower).
            where(user_id: @user.id).
            where(follow_type: Follow.follow_types[:user_follow]).
            #       ()should not force the role type of the results to match the logged in user!)
            where(User.roles[@user.role] == params[:role])
      end

      post '/old-dont-use-follow/:id', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @user_to_find = User.find(params[:id])
        @user = User.includes(:follows).find(@user.id)

        if @user_to_find != nil && !@user_to_find.id.in?(@user.follows.collect(&:follow_id))
          @follow = Follow.new
          @follow.user_id = @user.id
          @follow.follow_id = @user_to_find.id
          @follow.follow_type = 0

          @follow.save
          @follow
        end
      end

      post '/follow/:id', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        #@user_to_find = User.find(params[:id])

        #@user = User.includes(:follows).find(@user.id)
        follow = Follow.new
        follow.user_id = @user.id
        follow.follow_id = params[:id]
        #follow.follow_type = 0
        follow.follow_type = "user_follow"
        follow.save
        return follow

        #if @user_to_find != nil && !@user_to_find.id.in?(@user.follows.collect(&:follow_id))
        #  @follow = Follow.new
        #  @follow.user_id = @user.id
        #  @follow.follow_id = @user_to_find.id
        #  @follow.follow_type = 0

        #  @follow.save
        #  @follow
        #end
      end

      post '/unfollow/:id', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @follow = Follow.find(params[:id])

        if @follow != nil && @follow.user_id == @user.id
          @follow.delete
          true
        else
          error!("Not found")
        end


      end

      post '/upload', root: :user do
        error!('401 Unauthorized', 401) unless authenticated

        upload_file = params[:file]
        directory = 'public/images'

        if params[:file].present?

          time = Time.now.to_f.to_s
          name = time + '-' + @user_id.to_s + File.extname(upload_file[:tempfile]).to_s
          name_sm_thumb = time + '-' + @user_id.to_s + '-sm-thumb' + File.extname(upload_file[:tempfile]).to_s
          name_md_thumb = time + '-' + @user_id.to_s + '-md-thumb' + File.extname(upload_file[:tempfile]).to_s
          path = File.join(directory, name)
          path_sm_thumb = File.join(directory, name_sm_thumb)
          path_md_thumb = File.join(directory, name_md_thumb)

          File.open(path, 'wb') {|f| f.write(upload_file[:tempfile].read)}
          location = request.scheme + '://' + request.host_with_port + path.gsub('public', '')

          if File.extname(upload_file[:tempfile]).to_s === ".mp4" || File.extname(upload_file[:tempfile]).to_s === ".mov"
            {"location" => location}
          else
            # file = File.read(path, 'rb')

            img = MiniMagick::Image.open(path)
            # img = MiniMagick::Image::read(path).first
            puts(img.size)
            thumb = img.resize("500x500")
            thumb.write path_md_thumb

            thumb = img.resize("75x75")
            thumb.write path_sm_thumb


            sm_thumbnail = request.scheme + '://' + request.host_with_port + path_sm_thumb.gsub('public', '')
            md_thumbnail = request.scheme + '://' + request.host_with_port + path_md_thumb.gsub('public', '')


            {"location" => location, "sm_thumbnail" => sm_thumbnail, "md_thumbnail" => md_thumbnail}
          end

        else

        end
      end


      params do
        requires :role
      end
      post '/users-by-role', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        User.where(role: params[:role])
      end

      get '/:id', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        @user_to_find = User.find(params[:id])
        @user_to_find
        #SingleUserSerializer.new(@user_to_find)
      end

    end
  end
end