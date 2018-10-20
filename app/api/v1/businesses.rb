module V1
  class Businesses < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :businesses do

      desc 'Return all public businesses'
      get '/getAll', root: :businesses do
        Businesses.all
      end

      desc 'Return all vet businesses'
      get '/vet', root: :businesses do
        Business.where(business_type: 1)
      end

      desc 'Return all litter admin businesses'
      get '/litter_admin', root: :businesses do
        Business.where('business_type = ? or business_type = ?', 0, 2)
      end

      desc 'Return user businesses'
      get 'my-businesses', root: :businesses do
        @businesses = Business.where(user_id: @user.id)

        render @businesses, serializer: BusinessUsersSerializer
      end

      desc 'Return a user businesses'
      get 'user-businesses/:id', root: :businesses do
        @businesses = Business.where(user_id: params[:id])

        render @businesses, serializer: BusinessUsersSerializer
      end

      desc 'Search for a business'
      post 'search', root: :businesses do

        @businesses = Business.includes(:users, :user).where("name like ?", "%" + params[:search] + "%")
        render @businesses, serializer: BusinessUsersSerializer


      end

      desc 'Create a business'
      params do
        requires :name, type: String
        optional :desc, type: String
        optional :address, type: String
        optional :city, type: String
        optional :state, type: String
        optional :zip, type: String
        optional :email, type: String
        optional :phone, type: String
        optional :image, type: String
        optional :website, type: String
        optional :business_hours, type: Array
        optional :emergency_phone, type: String
      end
      post '', root: :businesses do
        if @business_to_find == nil
          @business = Business.new
          @business.name = params[:name]
          @business.desc = params[:desc]
          @business.address = params[:address]
          @business.city = params[:city]
          @business.state = params[:state]
          @business.zip = params[:zip]
          @business.email = params[:email]
          @business.phone = params[:phone]
          @business.image = params[:image]
          @business.license = params[:license]
          @business.website = params[:website]
          @business.business_hours = params[:business_hours]
          @business.emergency_phone = params[:emergency_phone]
          @business.user = @user

          if @user.role == 'litter_administrator'
            @business.business_type = 0
          elsif @user.role == 'rescue_admin'
            @business.business_type = 2
          elsif @user.role = 'vet'
            @business.business_type = 0
          end

          @business.save

          @business
        else
          @business_to_find.users.push(@user)
          @business_to_find.save

          @business_to_find
        end
      end


      desc 'Create a vet business'
      params do
        requires :name, type: String
        requires :license, type: String
        optional :desc, type: String
        optional :address, type: String
        optional :city, type: String
        optional :state, type: String
        optional :zip, type: String
        optional :email, type: String
        optional :phone, type: String
        optional :image, type: String
        optional :website, type: String
        optional :business_hours, type: Array
        optional :emergency_phone, type: String
      end
      post 'vet', root: :businesses do
        @business_to_find = Business.includes(:users).where('name = ? or license = ?', params[:name], params[:license]).first

        if @business_to_find == nil
          @business = Business.new
          @business.name = params[:name]
          @business.desc = params[:desc]
          @business.address = params[:address]
          @business.city = params[:city]
          @business.state = params[:state]
          @business.zip = params[:zip]
          @business.email = params[:email]
          @business.phone = params[:phone]
          @business.image = params[:image]
          @business.license = params[:license]
          @business.website = params[:website]
          @business.business_hours = params[:business_hours]
          @business.emergency_phone = params[:emergency_phone]
          @business.user = @user
          @business.business_type = 1
          @business.users.push(@user)

          @business

          @business.save
        else
          @business_to_find.users.push(@user)
          @business_to_find.save

          @business_to_find
        end

      end

      desc 'Update a business'
      params do
        requires :name, type: String
        optional :desc, type: String
        optional :address, type: String
        optional :city, type: String
        optional :state, type: String
        optional :zip, type: String
        optional :email, type: String
        optional :phone, type: Integer
        optional :image, type: String
        optional :website, type: String
        optional :license, type: String
        optional :business_hours, type: Array
        optional :emergency_phone, type: String
      end
      put '/:id', root: :businesses do
        @business = Business.find(params[:id])

        if @business != nil && @business.user_id == @user.id
          @business.name = params[:name]
          @business.desc = params[:desc]
          @business.address = params[:address]
          @business.city = params[:city]
          @business.state = params[:state]
          @business.zip = params[:zip]
          @business.email = params[:email]
          @business.phone = params[:phone]
          @business.image = params[:image]
          @business.license = params[:license]
          @business.website = params[:website]
          @business.business_hours = params[:business_hours]
          @business.emergency_phone = params[:emergency_phone]

          @business.save

          @business
        end

      end

      desc 'Adds currently logged in user to the business'
      post '/addUser/:id', root: :stories do

        @business = Business.find(params[:id])

        if @business != nil

          @business.users.push(@user)
          @business.save

        end
      end

      desc 'Deletes a specific business'
      delete '/:id', root: :stories do
        @business = Business.find(params[:id])

        if @business != nil && @business.user_id == @user.id
          @business.delete
          true
        else
          false
        end
      end

      desc 'Return a businesses'
      get '/:id', root: :businesses do
        @business = Business.find(params[:id])

        render @business, serializer: BusinessUsersSerializer
      end

      #params do
      #  requires :vet_id, type: Integer
      #end
      #desc "get all of a vet's pets"
      #get '/vetspets', root: :businesses do
      #  error!('401 Unauthorized', 401) unless authenticated
      #  puts(params[:vet_id])
        # with vet_id, find a business id
        # with the business id, find the pets belonging to that business
        #pet_to_business = Pet.biz
        #pet_to_business = Business.petz
        #return pet_to_business
      #  return "{}"
      #end

    end

  end
end