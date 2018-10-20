module V1
  class Alerts < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :alerts do
      desc 'Return alerts for user'
      get '/all', root: :alerts do
        error!('401 Unauthorized', 401) unless authenticated
        Alert.includes(:user).includes(:users).where(sender_user_id: @user.id).where("date_to_send > ?", DateTime.now)
      end

      desc 'Return alerts sent to user'
      get '/get-alerts-sent-to-me', root: :alerts do
        error!('401 Unauthorized', 401) unless authenticated

        Alert.joins(:alerts_users).where("alerts_users.receiver_user_id = #{@user.id}").where("date_to_send < ?", DateTime.now)
      end


      params do
        requires :content, type: String
        requires :category, type: String
        requires :users, type: Array
      end
      desc 'Create a new alert'
      post '/', root: :alerts do
        error!('401 Unauthorized', 401) unless authenticated

        users_to_add = params[:users]

        alert_to_create = @user.alerts.new
        alert_to_create.content = params[:content]
        alert_to_create.category = params[:category]

        alert_to_create.users = User.where(id: users_to_add)
        alert_to_create.save
      end

      #desc 'Create a new alert for the alert table'
      #post '/insert-alert', root: :alerts do
      #end

      params do
        requires :affected_pets, type: Array
        requires :date_to_send, type: String
        requires :category, type: String
        requires :content, type: String
      end
      desc 'create an alert for each pet owner of an affected pet'
      post '/schedule-alert', root: :alerts do
        error!('401 Unauthorized', 401) unless authenticated

        #affected_pets = params[:affected_pets].split(",").map(&:strip)
        affected_pets = params[:affected_pets]
        affected_litters = params[:affected_litters]

        alert = Alert.new do |a|
          a.sender_user_id = @user.id
          a.date_to_send = params[:date_to_send]
          a.category = params[:category]
          a.content = params[:content]
        end

        new_alert_exists = alert.save

        if new_alert_exists
          affected_pets.each do |pet_id|
            # get pet's owner from pet id
            pet = Pet.find_by(id: pet_id)

            affected_owner = User.find_by(id: pet.user_id)

            user_alert = AlertsUser.new
            user_alert.alert_id = alert.id
            user_alert.receiver_user_id = affected_owner.id
            user_alert.save

            PushNotification.new(affected_owner, @user.username + " has sent you an alert!").send_notification

          end
          return render :json => '{ success:  "true"}'

        else
          return render :json => '{ success: "false"}'
        end
      end

      post '/connections', root: :alerts do

        # We need to gather the affected pets and affected litters.
        # We will then grab the information that is correlated with these pets
        affected_pets = params[:affected_pets]
        affected_litters = params[:affected_litters]

        all_pets = Array.new

        litters = Litter.where(id: affected_litters).includes(:pets)

        # Let's get all the pets out of the litters
        litters.each do |litter|

          litter.pets.each do |pet|

            unless all_pets.any? {|p| p.id == pet.id}
              all_pets.push(pet)
            end

            all_pets.push(pet)

          end
        end

        # Get all the pets
        pets = Pet.includes(:litters, :businesses).where(id: affected_pets)

        pets.each do |pet|

          unless all_pets.any? {|p| p.id == pet.id}
            all_pets.push(pet)
          end

        end

        # Now we get all the pets from the DB with the unique values
        all_pets = Pet.includes(:litters, :businesses).find(all_pets.map(&:id).uniq)

        litter_connections = Array.new

        vet_connections = Array.new

        breeder_connections = Array.new

        all_pets.each do |pet|

          pet.litters.each do |litter|
            unless all_pets.any? {|l| l.id == litter.id}
              litter_connections.push(litter)
            end
          end

        end

        puts(affected_litters)

        all_pets

        return {pets: all_pets.as_json(include: :user), litter_connections: litter_connections.as_json}

      end

      params do
        requires :alert_id, type: Integer
      end
      desc 'removes an alert for a user'
      post '/remove-alert-for-user', root: :alerts do
        error!('401 Unauthorized', 401) unless authenticated

        alert = AlertsUser.where(receiver_user_id: @user.id).find_by(alert_id: params[:alert_id])

        if alert != nil && alert.receiver_user_id == @user.id
          puts("We in here!!")
          # update delete column with ISO8601 time of deletion
          alert.deleted_at = Time.now.strftime("%Y-%m-%dT%H%M%SZ")
          alert.delete

          true
        else
          error!("Not found")
        end
      end


    end
  end
end