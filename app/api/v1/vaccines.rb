module V1
  class Vaccines < Grape::API
    prefix 'api'

    require 'grape'
    include Defaults

    before do
      error!('401 Unauthorized', 401) unless authenticated
    end

    resource :vaccines do
      desc 'Return all vaccines'
      get '/all', root: :vaccines do
        Vaccine.all
      end

      get '/:id', root: :vaccines do
        @vaccine = Vaccine.find(params[:id])
        @vaccine
      end

      desc 'Create a vaccine'
      params do
        requires :name, type: String
        optional :desc, type: String
      end
      post '', root: :vaccines do
        @vaccine = Vaccine.new
        @vaccine.name = params[:name]
        @vaccine.desc = params[:desc]

        @vaccine.save

        @vaccine

      end

      desc 'Update a vaccine'
      params do
        optional :name, type: String
        optional :desc, type: String
      end
      put '/:id', root: :vaccines do
        @vaccine = Vaccine.find(params[:id])
        @vaccine.name = params[:name]
        @vaccine.desc = params[:desc]

        @vaccine.save

        @vaccine

      end

      desc 'Deletes a specific vaccine'
      delete '/:id', root: :stories do
        @vaccine = Vaccine.find(params[:id])

        if @vaccine != nil
          @vaccine.delete
          true
        else
          false
        end
      end

    end

  end
end