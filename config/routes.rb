# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'planning_center_families#new'

  get '/families/new/(:campus)' => 'planning_center_families#new', as: :new_family
  post '/families' => 'planning_center_families#create'
  get '/thank-you/(:campus)' => 'planning_center_families#thank_you', as: :thank_you
  get '/error' => 'planning_center_families#error'
end
