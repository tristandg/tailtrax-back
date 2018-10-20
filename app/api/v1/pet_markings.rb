module V1
  class PetMarkings < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pet_markings do
      desc 'Return all pet_markings'
      get '/getAll', root: :pet_markings do
        PetMarking.all
      end

      desc 'Create pet associated to logged in user'
      params do
        requires :name, type: String
      end
      post '', root: :pet_markings do
        @pet_markings = PetMarking.all
        @marking_exits = false

        @pet_markings.each do |pb|
          if pb.name == params[:name]
            @marking_exits = true
          end
        end

        if @marking_exits
          false
        else
          @pet_marking = PetMarking.new

          @pet_marking.name = params[:name]

          @pet_marking.save

          @pet_marking
        end
      end

      desc 'Update pet breed'
      params do
        requires :name, type: String
      end
      put '/:id', root: :pet_markings do
        @pet_markings = PetMarking.all
        @marking_exits = false
        @pet_marking = PetMarking.find(params[:id])

        @pet_markings.each do |pb|
          if pb.name == params[:name]
            @marking_exits = true
          end
        end

        if @marking_exits
          false
        elsif @pet_marking != nil
          @pet_marking.name = params[:name]

          @pet_marking.save

          @pet_marking
        else
          error!("Not found", 404)
        end
      end

      end

      desc 'Deletes a specific pet breed'
      delete '/:id', root: :pet_markings do
        @pet = Pet.find(params[:id])

        if @pet
          @pet.delete
          true
        else
          false
        end
      end

    end

  end
