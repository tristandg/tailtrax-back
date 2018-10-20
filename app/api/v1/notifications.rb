module V1
  class Notifications < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :notifications do

      desc 'Return all notifications'
      get '/getAll', root: :notifications do
        Notification.all
      end

      desc 'Return all notifications belonging to logged in user'
      get '', root: :notifications do
       @temp = Notification.where(user_id: @user.id).where.not(archived: true)
       @notifications = Array.new
       @temp.each do |notif|
         if notif[:post_date] == nil || notif[:post_date] < DateTime.now
           @notifications.push(notif)
         end
       end

        @notifications
      end

      desc 'Set notifications to read'
      params do
        requires :notifications, type: Array
      end
      post '/read', root: :notifications do
        @notifications = params[:notifications]

        @notification.each do |notif|
          @temp_notif = Notification.find(notif[:id])

          if @temp_notif != nil
            @temp_notif.is_read = true
            @temp_notif.save
          end
        end

        true
      end

      desc 'Set notifications to archived'
      params do
        requires :notifications, type: Array
      end
      post '/archive', root: :notifications do
        @notifications = params[:notifications]

        @notifications.each do |notif|
          @temp_notif = Notification.find(notif[:id])

          if @temp_notif != nil
            @temp_notif.is_read = true
            @temp_notif.archived = true
            @temp_notif.save
          end
        end

        true
      end

      desc 'Create a notifications to logged in user'
      post '', root: :notifications do
        @notification = Notification.new

        @notification.user_id = params[:user_id]
        @notification.from_id = params[:from_id]
        @notification.type = params[:type]
        @notification.message = params[:message]
        @notification.url = params[:url]

        @notification.save

        @notification

      end

      desc 'Deletes a specific notification'
      delete '/:id', root: :notifications do
        @notification = Notification.find(params[:id])

        if (@notification)
          @notification.delete
          true
        else
          false
        end
      end

    end

  end
end