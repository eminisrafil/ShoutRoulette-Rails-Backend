ShoutrouletteV2::Application.routes.draw do

  root to: "shouts#index"
  get '/room/:id/:position' => "rooms#show", as: 'show_room'

end
