module V1


  require_relative("../queries/get-new-conversations.rb")

  class DirectMessages < Grape::API


    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :direct_messages do
      desc 'Return all direct messages'
      get '/getAll', root: :direct_messages do
        DirectMessage.all
      end

      desc 'Return all direct messages belonging to logged in user'
      get '', root: :direct_messages do
        DirectMessage.where(user_id: @user.id)
      end

      desc 'Return all messages in conversation'
      get '/conversation/:id', root: :direct_messages do
        @conversation = Conversation.includes(:direct_messages).find(params[:id])

        if @user.id.in?(@conversation.users.collect(&:id))
          if @conversation != nil
            @conversation
          else
            error!('Error not found', 404)
          end
        end
      end

      desc 'Get all conversations for current user'
      get 'my-conversations', root: :direct_messages do
        @conversations = Array.new
        @user_to_find = User.includes(:conversations => :users).find(@user.id)

        @user_to_find.conversations.each do |convo|
          @conversations.push(convo)
        end

        render @conversations, serializer: UserConversationSerializer
      end

      params do
        requires :conversation_id, type: Integer
        requires :last_direct_message_id, type: Integer
      end
      desc 'Get all new conversations for current user'
      #get 'my-new-direct-messages/conversation/:conversation_id/message/:last_direct_message_id', root: :direct_messages do
      get 'my-new-direct-messages', root: :direct_messages do
        # puts params[:conversation_id]
        # puts params[:last_direct_message_id]
        # @new_convos = NewConversations.new()
        # new_conversations = @new_convos.get_new_conversations(params[:conversation_id], params[:last_direct_message_id])
        # puts @new_conversations
        #
        #
        new_convos = NewConversations.new

        results = new_convos.get_new_conversations params[:conversation_id], params[:last_direct_message_id]

        new_conversations = new_convos.reformat_query_results results

        s = new_convos.results_to_json results


        return s

      end

      desc 'Create a new conversation'
      params do
        requires :user_id, type: Integer
      end
      post 'new-conversation', root: :direct_messages do
        @current_user = User.includes(:conversations).find(@user.id)
        @user_to_find = User.find(params[:user_id])

        @create_convo = true

        @current_user.conversations.each do |con|
          con.users.each do |user|
            if @user_to_find.id == user.id
              @create_convo = false
            end
          end
        end

        if @create_convo
          @conversation = Conversation.new
          @conversation.users.push(@current_user, @user_to_find)

          @conversation.save

          render @conversation, serializer: UserConversationSerializer
        else
          false
        end
      end

      desc 'Create a direct associated to logged in user'
      params do
        requires :content, type: String
        requires :conversation_id, type: Integer
        optional :media, type: String
        optional :media_type, type: Integer
      end
      post '', root: :direct_messages do
        @dm = DirectMessage.new
        @dm.user_id = @user.id
        @dm.content = params[:content]
        @dm.media = params[:media]
        @dm.media_type = params[:media_type]
        @dm.conversation_id = params[:conversation_id]


        @conversation = Conversation.includes(:users).find(params[:conversation_id])

        @conversation.users.each do |user|

          if user.id != @user.id
            PushNotification.new(user, "@" + @user.username + " sent you a message").send_notification
          end
        end


        @dm.save

        @dm

      end

      desc 'Update a direct message associated to logged in user'
      params do
        requires :content, type: String
      end
      put '/:id', root: :direct_messages do
        @dm = DirectMessage.find(params[:id])
        @dm.content = params[:content]

        @dm.save

        @dm

      end

      desc 'Deletes a specific direct message'
      delete '/:id', root: :tasks do
        @dm = DirectMessage.find(params[:id])

        if (@dm)
          @dm.delete
          true
        else
          false
        end
      end

      post '/upload', root: :direct_messages do
        upload_file = params[:file]
        directory = 'public/images'

        @re

        if params[:file].present?
          puts Time.now.to_f.to_s
          name = Time.now.to_f.to_s + '-' + @user_id.to_s + request.headers["Extension"].to_s
          path = File.join(directory, name)

          File.open(path, 'wb') {|f| f.write(upload_file[:tempfile].read)}
          location = request.scheme + '://' + request.host_with_port + path.gsub('public', '')


          {"location" => location}

        end
      end

    end

  end
end