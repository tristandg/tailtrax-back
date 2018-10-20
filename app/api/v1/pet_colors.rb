module V1
  class PetColors < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pet_colors do
      desc 'Return all Pet Colors'
      get '/getAll', root: :pet_colors do
        PetColor.all
      end

      desc 'Create new pet color'
      params do
        requires :name, type: String
      end
      post '', root: :pet_colors do
        @pet_colors = PetColor.all
        @color_exists = false

        @pet_colors.each do |pc|
          if pc.name == params[:name]
            @color_exists = true
          end
        end

        if @color_exists
          false
        else
          @pet_color = PetColor.new

          @pet_color.name = params[:name]

          @pet_color.save

          @pet_color
        end
      end

      desc 'Update pet'
      params do
        requires :name, type: String
      end
      put '/:id', root: :pet_colors do
        @pet_colors = PetColor.all
        @color_exists = false
        @pet_color = PetColor.find(params[:id])

        @pet_colors.each do |pc|
          if pc.name == params[:name]
            @color_exists = true
          end
        end

        if @color_exists
          false
        elsif @pet_color != nil
          @pet_color.name = params[:name]
          @pet_color.save
          @pet_color
        else
          error!("Not found", 404)
        end



      end

      desc 'Deletes a specific pet'
      delete '/:id', root: :pet_colors do
        @pet_color = PetColor.find(params[:id])

        if @pet_color
          @pet_color.delete
          true
        else
          false
        end
      end

    end

  end
end
