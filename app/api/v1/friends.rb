module V1
  class Friends < Grape::API
    prefix 'api'

    require 'grape'

    include Defaults

    def self.token_expiration_date
      DateTime.now + 8760.hours
    end

    resource :friends do
      content_type :json, 'application/json'
      format :json

      params do
        requires :acceptor_id, type: Integer
      end
      post '/request-friend', root: :friends do
        error!('401 Unauthorized', 401) unless authenticated
        user_to_add = Friend.new
        user_to_add.friend_requestor_id = @user.id
        user_to_add.friend_acceptor_id = params[:acceptor_id]
        @user.requestors.push (user_to_add)
      end

      # 2
      params do
        requires :requestor_id, type: Integer
      end
      post 'accept-friend', root: :friends do
        error!('401 Unauthorized', 401) unless authenticated
        friendship = Friend.find_by(friend_requestor_id: params[:requestor_id], friend_acceptor_id: @user.id, has_accepted: 0)
        if not friendship.nil?
          friendship.has_accepted = 1
          friendship.save
        end
        return "{}"
      end

      get '/all-friends', root: :friends do
        error!('401 Unauthorized', 401) unless authenticated

        # find all records that have @user.id in friend_requestor_id, friend_acceptor_id
        #    bonus: omit record if it corresponds to @user.id ?
        if (@user.id.is_a? Integer) # protects against SQL injection?
           return Friend.includes(:requestor, :acceptor).
                     # following two don't work for some reason
                     #where({@user.id: [requestor.id, acceptor.id]})
                     #where ("friends.friend_requestor_id = ? OR friends.friend_acceptor_id = ?", @user.id, @user.id)
                     where ("friends.friend_requestor_id = #{@user.id} OR friends.friend_acceptor_id = #{@user.id}")
        end
        return "{}"

      end

      params do
        requires :role, type: String
      end
      get '/friends-by-role-type', root: :friends do
        error!('401 Unauthorized', 401) unless authenticated

        if (@user.id.is_a? Integer and params[:role].is_a? String) # protects against SQL injection?
          case params[:role]
             # "user", pet_parent", "litter_administrator", "vet", "rescue_admin", "admin", "super_admin""
          when "user_and_pet_parent"
                  return User.user_and_pet_parent_requestors | User.user_and_pet_parent_acceptors
                  #return User.user_requestors | User.user_acceptors
             when "user"
                  return User.user_requestors | User.user_acceptors
             when "pet_parent"
                  return User.pet_parent_requestors | User.pet_parent_acceptors
             when "litter_administartor"
               return User.litter_admin_requestors | User.litter_admin_acceptors
             when "vet"
                  return User.vet_requestors | User.vet_acceptors
             when "rescue_admin"
               return User.rescue_admin_requestors | User.rescue_admin_acceptors
             when "admin"
               return User.admin_requestors | User.admin_acceptors
             when "super_admin"
               return User.super_admin_requestors | User.super_admin_acceptors
             else
               return "{}"
          end
        end
        return "{}"

      end

    end
  end
end