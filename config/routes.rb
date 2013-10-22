ShoutrouletteV2::Application.routes.draw do
  # these routes need tons of work. but later

  root to: "shouts#index"
  get "invites/:room_id/:room_position" => "invites#index" 
  get 'room/:id/:position' => "rooms#show", as: 'show_room'

  scope 'pages', controller: 'pages' do
    get :about, :get_angry
  end

  get 'bunnies' => "admin#index", as: 'admin'
  delete 'topic/:id/remove' => "admin#remove_topic", as: 'remove_topic'
  delete 'room/:id/:position' =>"rooms#close"
  #post 'close' => "rooms#close"
  post 'topics/new' => "topics#new", as: 'new_topic'

end
