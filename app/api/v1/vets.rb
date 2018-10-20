module V1

  require_relative('../queries/find-vets.rb')

  class Vets < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end




    resource :vets do
      content_type :json, 'application/json'
      format :json

      params do
        optional :search_string, type: String
      end
      desc 'find a vet with first name'
      get '/getVet', root: :vets  do
         #search_string = "Nate"



         vets = FindVets.new
         results_by_search_string = vets.get_vet_by_search_string params[:search_string]
         json_results = "{}"
         if results_by_search_string != "{}"
            json_results = vets.results_to_json results_by_search_string
         end

         return json_results
      end




    end
  end
end
