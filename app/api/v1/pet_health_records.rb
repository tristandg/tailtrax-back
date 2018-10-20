module V1
  class PetHealthRecords < Grape::API
    prefix 'api'

    require 'grape'
    require 'rpush'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pet_health_records do

      desc 'Return all pet health records'
      get '/getAll', root: :pet_health_records do
        PetHealthRecord.all
      end

      desc 'Return all pet health records belonging to logged in user'
      get '', root: :pet_health_records do
        PetHealthRecord.where(user_id: @user.id)
      end

      desc 'Return all pet health records belonging to specific pet'
      get '/:id', root: :pet_health_records do
        PetHealthRecord.where(pet_id: params[:id])
      end

      desc 'Create a pet health record associated'
      params do
        requires :pet_id, type: Integer
        requires :check_in_date, type: Date
        optional :diagnosis_id, type: Integer
        optional :vaccine_id, type: Integer
        optional :medication_id, type: Integer
        optional :condition_notes, type: String
        optional :vet_id, type: Integer
        optional :reminders, type: Array
      end
      post '', root: :pet_health_records do
        @phr = PetHealthRecord.new
        @pet = Pet.find(params[:pet_id])
        @phr.user_id = params[:user_id]
        if @user.role == 'vet'
          @phr.vet_id = @user.id
        end
        @phr.pet_id = params[:pet_id]
        @phr.condition_notes = params[:condition_notes]
        @phr.vaccine_id = params[:vaccine_id]
        @phr.medication_id = params[:medication_id]
        @phr.diagnosis_id = params[:diagnosis_id]
        @phr.check_in_date = params[:check_in_date]
        @phr.reminders = params[:reminders]

        # REMINDER TYPES [:vaccine, :medication]
        # REMINDER REPEAT [:daily, :weekly, :monthly]
        if params[:reminders].present?
          @reminders = params[:reminders]

          @reminders.each do |r|
            if r[:reminder_type] == 0 && r[:repeat] != nil
              @start_date = Date.parse(r[:start_date])
              @end_date = Date.parse(r[:end_date])
              @days = (@end_date - @start_date).to_i
              @current_date = @start_date

              while @current_date < @end_date
                @post_date = @current_date
                if r[:repeat] == '0'
                  @current_date += 1.day
                elsif r[:repeat] == '1'
                   @current_date += 1.week
                   if @current_date > @end_date
                     break
                   end
                elsif r[:repeat] == '2'
                       @current_date += 1.month
                  if @current_date > @end_date
                    break
                  end
                else
                  break
                end

                @notification = Notification.new
                @notification.from_id = @user.id
                @notification.user_id = @pet.user_id
                @notification.notification_type = 7
                @notification.post_date = @post_date
                @notification.message = 'This is a reminder for your dog to take their medication.'
                @notification.save
              end
            else
              @notification = Notification.new
              @notification.from_id = @user.id
              @notification.user_id = @pet.user_id
              @notification.notification_type = 7
              @notification.post_date = Date.parse(r[:post_date])
              @notification.message = 'This is a reminder for your dog to get their vaccine.'
              @notification.save
            end
          end
        end


        if @user.id != @pet.user_id
          @notification = Notification.new
          @notification.from_id = @user.id
          @notification.user_id = @pet.user_id
          @notification.notification_type = 6
          @notification.message = 'You have a new pet health record entry.'
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

          @pet_user = User.find(@pet.user_id)
          if !@pet_user.push_token.nil?
            n = Rpush::Apns::Notification.new
            n.app = Rpush::Apns::App.find_by_name("ios_tt_app")
            n.device_token = @pet_user.push_token
            n.alert = "You have a new pet health record entry"
            # n.data = { test: :data }
            n.save!

            # Need to thread this out
            Thread.new do
              Rpush.push
            end
          end

          # Android
          # app = Rpush::Gcm::App.new
          # app.name = "android_app"
          # app.auth_key = "..."
          # app.connections = 1
          # app.save!
          # n = Rpush::Gcm::Notification.new
          # n.app = Rpush::Gcm::App.find_by_name("android_app")
          # n.registration_ids = ["..."]
          # n.data = { message: "hi mom!" }
          # n.priority = 'high'        # Optional, can be either 'normal' or 'high'
          # n.content_available = true # Optional
          # # Optional notification payload. See the reference below for more keys you can use!
          # n.notification = { body: 'great match!',
          #                    title: 'Portugal vs. Denmark',
          #                    icon: 'myicon'
          #                  }
          # n.save!
          #
        end

        @phr.save
        @phr

      end

      desc 'Update a pet health record associated to logged in user'
      params do
        optional :pet_id, type: Integer
        optional :check_in_date, type: Date
        optional :diagnosis_id, type: Integer
        optional :vaccine_id, type: Integer
        optional :medication_id, type: Integer
        optional :condition_notes, type: String
        optional :vet_id, type: Integer
      end
      put '/:id', root: :pet_health_records do
        @phr = PetHealthRecord.find(params[:id])

        @phr.user_id = params[:user_id]
        @phr.vet_id = params[:vet_id]
        @phr.pet_id = params[:pet_id]
        @phr.condition_notes = params[:condition_notes]
        @phr.vaccine_id = params[:vaccine_id]
        @phr.medication_id = params[:medication_id]
        @phr.diagnosis_id = params[:diagnosis_id]
        @phr.check_in_date = params[:check_in_date]

        @phr.save

        @phr

      end

      desc 'Deletes a specific phr'
      delete '/:id', root: :stories do
        @phr = PetHealthRecord.find(params[:id])

        if @phr != nil
          @phr.delete
          true
        else
          false
        end
      end

    end

  end
end