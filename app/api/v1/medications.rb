module V1
  class Medications < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :medications do
      desc 'Return all medications'
      get '/all', root: :medications do
        Medication.all
      end

      get '/:id', root: :medications do
        @medication = Medication.find(params[:id])
        @medication
      end


      desc 'Create a medication associated to logged in user'
      params do
        requires :name, type: String
        optional :desc, type: String
      end
      post '', root: :medications do
        @medication = Medication.new
        @medication.name = params[:name]
        @medication.desc = params[:desc]

        @medication.save

        @medication

      end

      desc 'Update a medication'
      params do
        optional :name, type: String
        optional :desc, type: String
      end
      put '/:id', root: :medications do
        @medication = Medication.find(params[:id])
        @medication.name = params[:name]
        @medication.desc = params[:desc]

        @medication.save

        @medication

      end

      desc 'Deletes a specific medication'
      delete '/:id', root: :stories do
        @medication = Medication.find(params[:id])

        if @medication != nil
          @medication.delete
          true
        else
          false
        end
      end

    end

  end
end