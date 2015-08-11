TaskMaster::Engine.routes.draw do
  post "webhook", to: "webhook#create"
end
