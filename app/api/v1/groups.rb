module V1
  class Groups < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :groups do

      desc 'Return all public groups'
      get '', root: :groups do
        Group.where(is_private: false)
      end

      desc 'Return user groups'
      get 'my-groups', root: :groups do
        @user = User.includes(:groups).find(@user.id)

        @user_groups = @user.groups

        @groups = Array.new

        Group.where(user_id: @user.id).each do |group|
          @groups.push(group)
        end

        if @user_groups
          @groups = @groups + @user_groups
        end

        @groups
      end

      desc 'Create invites to group users'
      params do
        requires :users, type: Array
      end
      post 'invite_users/:id', root: :groups do
        @invited_users = params[:users]
        @group = Group.find(params[:id])

        if @group.user_id == @user.id
          @invited_users.each do |iu|
            @invited_user = User.find(iu[:id])

            if @user != nil
              @notification = Notification.new
              @notification.from_id = @user.id
              @notification.user_id = @invited_user.id
              @notification.group_id = @group.id
              @notification.message = @group.name + " would like you to join their group."
              @notification.notification_type = 4

              @notification.save

              # iOS
              push_app = Rpush::Apns::App.find_by_name("ios_tt_app")
              if (push_app == nil)
                cert = File.read(Rails.root.join('public/certs/aps_development.pem'))
                app = Rpush::Apns::App.new
                app.name = "ios_tt_app"
                app.certificate = cert
                app.environment = "development"
                app.password = "tailtrax"
                app.connections = 1
                app.save!
              end

              @notification_user = User.find(@invited_user.id)
              if !@notification_user.push_token.nil?
                n = Rpush::Apns::Notification.new
                n.app = Rpush::Apns::App.find_by_name("ios_tt_app")
                n.device_token = @notification_user.push_token
                n.alert = @group.name + " would like you to join their group."
                # n.data = { test: :data }
                n.save!

                # Need to thread this out
                Thread.new do
                  Rpush.push
                end
              end

            end
          end
          true
        else
          false
        end
      end

      desc 'Create a group'
      params do
        requires :name, type: String
        optional :desc, type: String
        optional :image, type: String
        optional :is_private, type: Boolean
        optional :users, type: Array
      end
      post '', root: :groups do
        @group = Group.new
        @group.name = params[:name]
        @group.user = @user
        @group.image = params[:image]
        @group.is_private = params[:is_private]
        @group.desc = params[:desc]

        @group.save

        @invited_users = params[:users]

        @invited_users.each do |iu|
          @invited_user = User.find(iu[:id])

          if @user != nil
            @notification = Notification.new
            @notification.from_id = @user.id
            @notification.user_id = @invited_user.id
            @notification.group_id = @group.id
            @notification.message = @group.name + " would like you to join their group."
            @notification.notification_type = 4

            @notification.save

            # iOS
            push_app = Rpush::Apns::App.find_by_name("ios_tt_app")
            if (push_app == nil)
              cert = File.read(Rails.root.join('public/certs/aps_development.pem'))
              app = Rpush::Apns::App.new
              app.name = "ios_tt_app"
              app.certificate = cert
              app.environment = "development"
              app.password = "tailtrax"
              app.connections = 1
              app.save!
            end

            @notification_user = User.find(@invited_user.id)
            if !@notification_user.push_token.nil?
              n = Rpush::Apns::Notification.new
              n.app = Rpush::Apns::App.find_by_name("ios_tt_app")
              n.device_token = @notification_user.push_token
              n.alert = @group.name + " would like you to join their group."
              # n.data = { test: :data }
              n.save!

              # Need to thread this out
              Thread.new do
                Rpush.push
              end
            end
          end
        end

        @group
      end

      desc 'Accepts group invite'
      post 'accept_invite/:id', root: :groups do
        @notification = Notification.find(params[:id])

        if @notification != nil && @notification.user_id == @user.id && @notification.group_id != nil
          @group = Group.includes(:users).find(@notification.group_id)

          if @group != nil && !@user.id.in?(@group.users.collect(&:id))
            @group.users.push(@user)
            @group.save
          end

          @notification.is_read = true
          @notification.archived = true

          @notification.save

          true
        else
          false
        end
      end

      desc 'Declines group invite'
      post 'decline_invite/:id', root: :groups do
        @notification = Notification.find(params[:id])

        if @notification != nil && @notification.user_id == @user.id

          @notification.is_read = true
          @notification.archived = true

          @notification.save

          true
        else
          false
        end
      end

      desc 'Sends group request to group admin'
      post 'group_request/:id', root: :groups do
        @group = Group.find(params[:id])

        if @group != nil
          @group_request = Notification.where(from_id: @user.id).where(user_id: @group.user_id).where(notification_type: 'group_request').first

          if @group_request == nil
            @new_request = Notification.new

            @new_request.from_id = @user.id
            @new_request.user_id = @group.id
            @new_request.notification_type = 5
            @new_request.message = @user.first_name + " " + @user.last_name + " would like to join your group."
            @new_request.save
          end
        else
          error!("Group not found", 404)
        end
      end

      desc 'Group admin accepts group request'
      post 'group_request/accept/:group_request_id', root: :groups do
        @notification = Notification.find(params[:group_request_id])

        if @notification != nil && @notification.group_id != nil
          @group = Group.find(@notification.group_id)

          if @group != nil
            @user_to_find = User.find(group.from_id)
            if @user_to_find && !@user_to_find.id.in?(@group.users.collect(&:id))
              @group.users.push(@user)
              @group.save
            end

            @notification.is_read = true
            @notification.archived = true

            @notification.save
          else
            error!("Group not found", 404)
          end
        else
          error!("Not found", 404)
        end

      end

      desc 'Update a group'
      params do
        optional :name, type: String
        optional :desc, type: String
        optional :image, type: String
        optional :is_private, type: Boolean
      end
      put '/:id', root: :groups do
        @group = Group.find(params[:id])

        if @group != nil && @group.user_id == @user.id
          @group.name = params[:name]
          @group.image = params[:image]
          @group.is_private = params[:is_private]
          @group.desc = params[:desc]

          @group.save

          @group
        end

      end

      desc 'Deletes a specific group'
      delete '/:id', root: :groups do
        @group = Group.find(params[:id])

        if @group != nil && @group.user_id
          @group.delete
          true
        else
          false
        end
      end

      desc 'Removes member from group'
      params do
        requires :user_id, type: Integer
      end
      post '/members/remove/:id', root: :groups do
        @group = Group.find(params[:id])
        @user_to_find = User.find(params[:user_id])

        if @group != nil && @user_to_find != nil && @group.user_id == @user.id
          @group.users.delete(@user_to_find)
          true
        else
          error!("Not found", 404)
        end
      end

      desc 'Gets members in group'
      get '/members/:id', root: :groups do
        @group = Group.includes(:users).find(params[:id])

        render @group, serializer: GroupMembersSerializer
      end

      desc 'Return specific group'
      get '/:id', root: :groups do
        Group.find(params[:id])
      end

    end
  end
end