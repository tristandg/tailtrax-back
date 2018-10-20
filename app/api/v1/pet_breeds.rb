module V1
  class PetBreeds < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pet_breeds do
      desc 'Return all pet_breeds'
      get '/getAll', root: :pet_breeds do
        PetBreed.all
      end

      desc 'Create pet associated to logged in user'
      params do
        requires :name, type: String
      end
      post '', root: :pet_breeds do
        @pet_breed = PetBreed.new

        @pet_breed.name = params[:name]

        @pet_breed.save

        @pet_breed

      end

      desc 'Update pet'
      params do
        requires :name, type: String
      end
      put '/:id', root: :pet_breeds do
        @pet_breed = PetBreed.find(params[:id])

        @pet_breed.name = params[:name]

        @pet_breed.save

        @pet_breed

      end

      desc 'Deletes a specific pet'
      delete '/:id', root: :pet_breeds do
        @pet_breed = PetBreed.find(params[:id])

        if @pet
          @pet_breed.delete
          true
        else
          false
        end
      end

    end

  end
end
