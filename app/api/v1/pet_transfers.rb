module V1
  class PetTransfers < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pet_transfers do

      desc 'Return all pets'
      get '/my-transfers', root: :pet_transfer do
        PetTransfer.where(user_id: @user.id).where('accepted != ?', true)
      end


      desc 'Create a pet transfer for a user'
      params do
        requires :user_id, type: Integer
        requires :pet_id, type: Integer
      end
      post '', root: :pet_transfers do
        @user_to_find = User.find(params[:user_id])
        @pet = Pet.find(params[:pet_id])

        if @user_to_find != nil && @pet != nil
          @pet_transfer = PetTransfer.new
          @pet_transfer.user_id = @user_to_find.id
          @pet_transfer.pet_id = @pet.id
          @pet_transfer.from_id = @user.id
          @pet_transfer.save

          @notification = Notification.new
          @notification.from_id = @user.id
          @notification.user_id = @user_to_find.id
          @notification.notification_type = 2
          @notification.message = "You have a new pet transfer request.";
          @notification.save

          @pet_transfer
        end

      end

      desc 'Accept a pet transfer'
      post '/accept/:id', root: :pet_transfers do
        @pet_transfer = PetTransfer.find(params[:id])

        if @pet_transfer != nil && @pet_transfer.user_id == @user.id
          @pet_of_transfer = @pet_transfer.pet
          @pet_of_transfer.user_id = @user.id
          @pet_of_transfer.save

          @pet_transfer.accepted = true
          @pet_transfer.save

          @pet_of_transfer
        else
          error!('Not found', 404)
        end
      end

      post '/decline/:id', root: :pet_transfers do
        @pet_transfer = PetTransfer.find(params[:id])

        if @pet_transfer.user_id == @user.id
          @pet_transfer.delete
        end
      end

    end

  end
end
