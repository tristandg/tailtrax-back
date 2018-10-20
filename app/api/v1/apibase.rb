module V1
  class APIBASE < Grape::API
    prefix 'api'
    mount Users

    mount Pets
    mount Litters

    mount DirectMessages
    mount SocialPosts
    mount Groups
    mount PetTransfers

    mount PetHealthRecords

    mount Notifications
    mount PetBreeds
    mount PetColors
    mount PetMarkings
    mount Groups
    mount Businesses
    mount Diagnoses
    mount Vaccines
    mount Medications
    mount Vets
    mount SocialLogin
    mount Alerts
    mount Friends
    mount BusinessesPets

    require 'grape-swagger'
    add_swagger_documentation(
        api_version: 'v1',
        hide_documentation_path: true,
        mount_path: '/v1/swagger_doc',
        hide_format: true
    )
  end
end