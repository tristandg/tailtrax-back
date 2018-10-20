module V1
  class Litters < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :litters do


      desc 'Return all litters'
      get '/all', root: :litters do
        Litter.all
      end

      desc 'Return all litters belonging to logged in user'
      get '', root: :litters do
        Litter.where('user_id = ' + @user.id.to_s)
      end

      get '/:id', root: :litters do
        @litter = Litter.find(params[:id])
        @litter
      end

      get '/pet/:id', root: :litters do
        @pet = Pet.includes(:litters).find(params[:id])
        @litter = @pet.litters
        @litter
      end

      desc 'Create a litter associated to logged in user'
      params do
        requires :name, type: String
        optional :litter_description, type: String
        optional :pet_mom_id, type: Integer
        optional :pet_dad_id, type: Integer
        optional :birthday, type: Date
        optional :pets, type: Array
      end
      post '', root: :litters do
        @litter = Litter.new
        @litter.user_id = @user.id
        @litter.name = params[:name]
        @litter.litter_description = params[:litter_description]
        @litter.birthday = params[:birthday]
        @litter.pet_mom_id = params[:pet_mom_id]
        @litter.pet_dad_id = params[:pet_dad_id]

        @pets = params[:pets]

        @pets.each do |pet|
          @temp_pet = Pet.find(pet[:id])

          if @temp_pet != nil
            @litter.pets.push(@temp_pet)
          end
        end

        @litter.save

        @litter

      end

      desc 'Update a litter associated to logged in user'
      params do
        requires :name, type: String
        optional :litter_description, type: String
        optional :pet_mom_id, type: Integer
        optional :pet_dad_id, type: Integer
        optional :birthday, type: Date
      end
      put '/:id', root: :litters do
        @litter = Litter.find(params[:id])
        @litter.user_id = @user.id
        @litter.name = params[:name]
        @litter.litter_description = params[:litter_description]
        @litter.birthday = params[:birthday]
        @litter.pet_mom_id = params[:pet_mom_id]
        @litter.pet_dad_id = params[:pet_dad_id]

        #@litter.pets = params[:pets]

        if params[:pets].present?
          @temp_array = Array.new
          @temp_pets = params[:pets]
          if @temp_pets.length > 0
            @temp_pets.each do |t|
              @temp_p = Pet.find(t[:id])
              if @temp_p != nil
                @temp_array.push(@temp_p)
              end
            end
            @litter.pets = @temp_array
          else
            @litter.pets = Array.new
          end
        else
          @litter.pets = Array.new
        end

        @litter.save

        @litter

      end

      desc 'Deletes a specific litter'
      delete '/:id', root: :stories do
        @litter = Litter.find(params[:id])

        if (@litter)
          @litter.delete
          true
        else
          false
        end
      end

    end

  end
end