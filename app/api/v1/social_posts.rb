module V1
  class SocialPosts < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :social_posts do

      ### GENERIC SOCIAL POSTS

      desc 'Return all social posts'
      get '/getAll', root: :social_posts do
        SocialPost.where(group_id: nil).order(created_at: :desc).includes(:social_likes, :social_comments, :user)
      end

      desc 'Return all social posts belonging to logged in user'
      get '', root: :social_posts do
        SocialPost.where(user_id: @user.id).order(created_at: :desc)
      end

      desc 'Return all social posts belonging to group'
      get 'group-posts/:id', root: :social_posts do
        SocialPost.where(group_id: params[:id]).order(created_at: :desc)
      end

      desc 'Create a social post associated to logged in user'
      params do
        optional :content, type: String
        optional :title, type: String
        optional :media, type: String
        optional :media_type, type: Integer
        optional :group_id, type: Integer
      end
      post '', root: :social_posts do
        @sp = SocialPost.new
        @sp.user_id = @user.id
        @sp.content = params[:content]
        @sp.title = params[:title]
        @sp.media = params[:media]
        @sp.media_type = params[:media_type]
        @sp.group_id = params[:group_id]

        @user.followeds.each do |user|
          puts(user.follower.inspect)
          PushNotification.new(user.follower, "@" + @user.username + " made a paw post!").send_notification
        end

        @sp.save

        @sp

      end

      desc 'Update a social post associated to logged in user'
      params do
        requires :user_id_to, type: Integer
        # requires :content, type: String
      end
      put '/:id', root: :social_posts do
        @sp = SocialPost.find(params[:id])
        @sp.content = params[:content]
        @sp.title = params[:title]
        @sp.media = params[:media]
        @sp.media_type = params[:media_type]

        @sp.save

        @sp

      end

      desc 'Deletes a specific social post'
      delete '/:id', root: :social_posts do
        @sp = SocialPost.find(params[:id])

        if @sp != nil && @sp.user_id == @user.id
          @sp.delete
          true
        else
          false
        end
      end

      ### GENERIC LIKES

      params do
        requires :post_id, type: Integer
      end
      desc 'like a specific post'
      post '/like', root: :social_posts do
        @spl = SocialLike.new
        @spl.user_id = @user.id
        @spl.social_like_type = 0

        @social_post = SocialPost.find(params[:post_id])

        if @social_post != nil
          if @social_post.user_id != @user.id
            @notification = Notification.new
            @notification.from_id = @user.id
            @notification.user_id = @social_post.user_id
            @notification.notification_type = 1
            @notification.post_id = @social_post.id
            @notification.message = 'Someone liked your post.'
            @notification.save
          end


          @notification_user = User.find(@social_post.user_id)

          PushNotification.new(@notification_user, @user.username + " liked your post.").send_notification


          @spl.social_post = @social_post
          @spl.save

          @spl
        else
          error!('Social Post Not Found', 404)
        end
      end

      delete '/like/:id', root: :user do

        @like = SocialLike.where(user_id: @user.id).where(social_post_id: params[:id]).first

        @notification = Notification.where(from_id: @user.id).where(post_id: params[:id]).where(notification_type: 'like').first

        if @notification != nil
          @notification.delete
        end

        if @like != nil && @like.user_id == @user.id
          @like.delete
        end
      end

      ### GENERIC COMMENTS

      params do
        requires :post_id, type: Integer
        optional :content, type: String
        optional :media, type: String
        optional :media_type, type: Integer
      end
      desc 'like a specific post'
      post '/comment', root: :social_posts do
        @spc = SocialComment.new
        @spc.user_id = @user.id
        @spc.content = params[:content]
        @spc.media = params[:media]
        @spc.media_type = params[:media_type]

        @social_post = SocialPost.find(params[:post_id])

        if @social_post != nil
          @spc.social_post = @social_post
        end

        @spc.save

        if @social_post.user_id != @user.id
          @notification = Notification.new
          @notification.from_id = @user.id
          @notification.user_id = @social_post.user_id
          @notification.post_id = @social_post.id
          @notification.notification_type = 0
          @notification.message = 'Someone commented on your post.'
          @notification.save

          @notification_user = User.find(@social_post.user_id)

          PushNotification.new(@notification_user, "@" + @user.username + " commented on your post.").send_notification

        end

        @spc
      end

      desc 'Create a report on a post'
      post 'report/:post_id', root: :social_posts do
        @post_report = PostReport.where(post_id: params[:post_id]).where(user_id: @user.id).first

        if @post_report == nil
          @post_report = PostReport.new
          @post = SocialPost.find(params[:post_id])
          if @post != nil
            @post_report.post_id = @post.id
            @post_report.user_id = @user.id

            @post_report.save

            @post_report
          else
            error!('Not found', 404)
          end
        else
          error!('Report already exists', 405)
        end

      end

      post '/upload', root: :social_posts do
        upload_file = params[:file]
        directory = 'public/images'

        if params[:file].present?
          name = Time.now.to_f.to_s + '-' + @user_id.to_s + File.extname(upload_file[:tempfile]).to_s
          path = File.join(directory, name)

          File.open(path, 'wb') {|f| f.write(upload_file[:tempfile].read)}
          location = request.scheme + '://' + request.host_with_port + path.gsub('public', '')


          {"location" => location}
        end
      end

      get '/reports', root: :user do
        error!('401 Unauthorized', 401) unless authenticated
        PostReport.where(user_id: @user.id)
      end

    end

  end
end