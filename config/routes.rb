ShoutrouletteV2::Application.routes.draw do

  root to: "shouts#index"
  get 'room/:id/:position' => "rooms#show", as: 'show_room'
  get 'about' => "pages#about", as: 'about'
  get 'bunnies' => "admin#index", as: 'admin'
  delete 'topic/:id/remove' => "admin#remove_topic", as: 'remove_topic'
  post 'close' => "rooms#close"

end
