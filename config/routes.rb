Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #SITE ROOT
  root 'home#index'

  # #GRAPE API
  mount BASE, at: '/'

  #GRAPE SWAGGER
  mount GrapeSwaggerRails::Engine => '/apidoc'
end
