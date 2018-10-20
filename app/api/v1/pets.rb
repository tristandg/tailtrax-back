module V1
  class Pets < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :pets do

      desc 'Return all pets'
      get '/getAll', root: :pets do
        Pet.includes(:pet_health_records, :medications, :diagnoses, :vaccines).all
      end

      get '/getOthers', root: :pets do
        Pet.includes(:pet_health_records, :medications, :diagnoses, :vaccines).where.not(user_id: @user.id)
      end

      get '/user/:id', root: :pets do
        Pet.includes(:pet_health_records, :medications, :diagnoses, :vaccines).where(user_id: params[:id])
      end

      desc 'Return all pets belonging to logged in user'
      get '', root: :pets do
        Pet.includes(:pet_health_records, :medications, :diagnoses, :vaccines).where(user_id: @user.id)
      end

      desc 'Adding a vet to a pet'
      params do
        requires :vet_id, type: Integer
      end
      post 'addVet/:id', root: :pets do
        @pet = Pet.find(params[:id])
        @vet = Business.find(params[:vet_id])

        if (@pet && @vet) != nil
          if @pet.id.in?(@vet.pets.collect(&:id))
            false
          else
            @vet.pets.push(@pet)
            @vet
          end
        end
      end

      desc 'Removing a vet from a pet'
      params do
        requires :vet_id, type: Integer
      end
      post 'removeVet/:id', root: :pets do
        @pet = Pet.find(params[:id])
        @vet = Business.find(params[:vet_id])

        if @pet.user_id == @user.id
          @vet.pets.delete(@pet)
          true
        else
          false
        end
      end

      desc 'Return specific dog'
      get '/:id', root: :pets do
        @pet = Pet.includes(:pet_health_records, :medications, :diagnoses, :vaccines, :litters).find(params[:id])
        if @pet != nil
          @pet
        else
          error!("Dog not found", 404)
        end
      end

      desc 'Create pet associated to logged in user'
      params do
        requires :name, type: String
        requires :birthday, type: Date
        optional :pet_breed, type: PetBreed
        optional :pet_color, type: PetColor
        optional :pet_markings, type: PetMarking
        optional :gender, type: Integer
        optional :weight, type: Integer
        optional :pet_description, type: String
        optional :microchip, type: String
        optional :location, type: String
        optional :akc_reg_number, type: String
        optional :akc_reg_date, type: Date
      end
      post '', root: :pets do
        @pet = Pet.new
        @pet.user_id = @user.id
        @pet.name = params[:name]
        @pet.gender = params[:gender]
        @pet.weight = params[:weight]
        @pet.pet_description = params[:pet_description]
        @pet.pet_profile_pic = params[:pet_profile_pic]
        @pet.location = params[:location]
        @pet.microchip = params[:microchip]
        @pet.akc_reg_number = params[:akc_reg_number]
        @pet.akc_reg_date = params[:akc_reg_date]
        @pet.birthday = params[:birthday]
        @pet.health_issue = params[:health_issue]
        @pet.food = params[:food]
        @pet.supplemental = params[:supplemental]

        if params[:pet_breed]
          @breed = PetBreed.find(params[:pet_breed][:id])

          if @breed != nil
            @pet.pet_breed = @breed
          end
        end

        if params[:pet_color]
          @color = PetColor.find(params[:pet_color][:id])

          if @color != nil
            @pet.pet_color = @color
          end
        end

        if params[:pet_markings]
          @marking = PetMarking.find(params[:pet_markings][:id])

          if @marking != nil
            @pet.pet_marking = @marking
          end
        end



        @pet.save

        @pet

      end

      desc 'Update pet'
      params do
        optional :name, type: String
        optional :birthday, type: Date
        optional :gender, type: Integer
        optional :weight, type: Integer
        optional :pet_description, type: String
        optional :breed_id, type: String
        optional :color_id, type: Integer
        optional :pet_markings, type: String
        optional :microchip, type: String
        optional :location, type: String
        optional :akc_reg_number, type: String
        optional :akc_reg_date, type: Date
      end
      put '/:id', root: :pets do
        @pet = Pet.find(params[:id])

        @pet.user_id = @user.id
        @pet.name = params[:name]
        @pet.gender = params[:gender]
        @pet.weight = params[:weight]
        @pet.pet_description = params[:pet_description]
        @pet.pet_profile_pic = params[:pet_profile_pic]
        @pet.background_image = params[:background_image]
        @pet.color_id = params[:color_id]
        @pet.markings = params[:markings]
        @pet.location = params[:location]
        @pet.microchip = params[:microchip]
        @pet.akc_reg_number = params[:akc_reg_number]
        @pet.akc_reg_date = params[:akc_reg_date]
        @pet.birthday = params[:birthday]
        @pet.health_issue = params[:health_issue]
        @pet.food = params[:food]
        @pet.supplemental = params[:supplemental]

        @pet.save

        @pet

      end

      desc 'Deletes a specific pet'
      delete '/:id', root: :stories do
        @pet = Pet.find(params[:id])

        if (@pet)
          @pet.delete
          true
        else
          false
        end
      end


      post '/upload', root: :pets do
        upload_file = params[:file]
        directory = 'public/images'

        if params[:file].present?
          name = Time.now.to_f.to_s + '-' + @user_id.to_s + File.extname(upload_file[:tempfile]).to_s
          path = File.join(directory, name)

          File.open(path, 'wb') { |f| f.write(upload_file[:tempfile].read) }
          location = request.scheme + '://' + request.host_with_port + path.gsub('public', '')


          { "location" => location }
        end
      end

    end

  end
end
