module V1
  class BusinessesUsers < Grape::API
    prefix 'api'

    require 'grape'

    include Defaults

    def self.token_expiration_date
      DateTime.now + 8760.hours
    end

    resource :businesses_users do
      content_type :json, 'application/json'
      format :json


      params do
        requires :vet_id, type: Integer
      end
      desc "get all of a vet's pets"
#### UNUSED
      get '/vets-petss', root: :businesses_users do
        # with vet_id, find a business id
        #return User.includes(:user_to_businesses)
        #return Business.petz
        # stopped here. just returning user data and need business data too.
        render Business.petz, serializer: BusinessUsersSerializer

        # with the business id, find the pets belonging to that business
        #pet_to_business = Pet.biz
        #pet_to_business = Pet.biz
        #return pet_to_business
        #return "{}"
      end

    end
  end
end