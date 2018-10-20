module V1
  class BusinessesPets < Grape::API
    prefix 'api'

    require 'grape'

    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end
    resource :businesses_pets do
      content_type :json, 'application/json'
      format :json


      # params do
      #   requires :vet_id, type: Integer
      # end
      # desc "get all of a vet's or breeder's pets by a user in that organization"
      # get '/vets-pets', root: :businesses_pets do
      #   # with vet_id, find a business id
      #   users_businesses = User.my_businesses (params[:vet_id])
      #   # next line works
      #   #render users_businesses, serializer:  BusinessUsersSerializer
      #
      #
      #   # just added case in businesses_users where a business (#5) has two people (#35, #39)
      #   # need all pets that business #5 has plus business #1 as user #39 belongs to business #1 and
      #   # business #5
      #
      #   biz_pets = Array.new
      #   users_businesses.each do |biz|
      #     puts("biz id: #{biz.id}, #{biz.name}")
      #     # with the business id, find the pets belonging to that business
      #     pets_per_biz = Pet.biz_pets (biz.id)
      #     #biz_pets.insert(render pets_per_biz, serializer: PetSkeletonInfoSerializer)
      #     biz_pets = biz_pets | pets_per_biz
      #   end
      #   # take all of the saved pets and return them now
      #   return render biz_pets, serializer: PetSkeletonInfoSerializer
      # end


      desc "get all of a vet's or breeder's pets by a user in that organization"
      get '/vets-pets', root: :businesses_pets do
        # with vet_id, find a business id
        users_businesses = User.includes(:businesses => :pets).find(@user.id)

        business_pets = Array.new

        users_businesses.businesses.each do |business|
          business.pets.each do |pet|
            business_pets.push(pet)
          end
        end

        business_pets

      end
      params do
        requires :pet_id, type: Integer
      end
      desc "get all of a vet's or breeder's pets by a user in that organization"
      post '/vets-pets', root: :businesses_pets do

        # with vet_id, find a business id
        users_businesses = User.includes(:businesses).includes(:businesses_users).find(@user.id)

        pet_to_add = Pet.find(params[:pet_id])

        if pet_to_add != nil

          users_businesses.businesses.each do |business|
            business.pets.push(pet_to_add)
          end

          users_businesses.businesses_users.each do |business|
            business.pets.push(pet_to_add)
          end

          pet_to_add

        end


      end

    end
  end
end