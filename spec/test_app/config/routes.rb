Rails.application.routes.draw do
  mount TaskMaster::Engine => "/task_master"
end
