module V1
  class Diagnoses < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :diagnoses do
      desc 'Return all diagnoses'
      get '/all', root: :diagnoses do
        Diagnosis.all
      end

      get '/:id', root: :diagnoses do
        @diagnosis = Diagnosis.find(params[:id])
        @diagnosis
      end


      desc 'Create a diagnosis'
      params do
        requires :name, type: String
        optional :desc, type: String
        optional :severity, type: Integer
      end
      post '', root: :diagnoses do
        @diagnosis = Diagnosis.new
        @diagnosis.name = params[:name]
        @diagnosis.desc = params[:desc]
        @diagnosis.severity = params[:severity]

        @diagnosis.save

        @diagnosis

      end

      desc 'Update a diagnosis'
      params do
        optional :name, type: String
        optional :desc, type: String
        optional :severity, type: Integer
      end
      put '/:id', root: :diagnoses do
        @diagnosis = Diagnosis.find(params[:id])
        @diagnosis.name = params[:name]
        @diagnosis.desc = params[:desc]
        @diagnosis.severity = params[:severity]

        @diagnosis.save

        @diagnosis

      end

      desc 'Deletes a specific diagnosis'
      delete '/:id', root: :stories do
        @diagnosis = Diagnosis.find(params[:id])

        if @diagnosis != nil
          @diagnosis.delete
          true
        else
          false
        end
      end

    end

  end
end